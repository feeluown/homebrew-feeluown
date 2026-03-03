class Feeluown < Formula
  include Language::Python::Virtualenv

  desc "A user-friendly and hackable music player"
  homepage "https://github.com/feeluown/"
  url "https://files.pythonhosted.org/packages/91/c3/c4f04d2114c1a5f1efbf63910425567b1b889bebe4fcd247f7a685db19a6/feeluown-5.1.tar.gz"
  sha256 "359cbbfe04fa453918b36a862ef71060bf0156481fd8619a45c20206ef13caf0"

  depends_on "python@3.11"
  depends_on "pyqt@6"
  depends_on "mpv"

  option "with-battery", "feeluown battery"
  option "with-qqmusic", "feeluown qqmusic plugin"
  option "with-netease", "feeluown netease plugin"
  option "with-ytmusic", "feeluown ytmusic plugin"
  option "with-bilibili", "feeluown bilibili plugin"
  option "tsinghua-pypi", "use Tsinghua PyPI mirror for pip install"
  option "aliyun-pypi", "use Aliyun PyPI mirror for pip install"
  option "douban-pypi", "use Douban PyPI mirror for pip install"

  def install
    _plugins = []
    _netease = "fuo-netease"
    _qqmusic = "fuo-qqmusic"
    _ytmusic = "fuo-ytmusic"
    _bilibili = "feeluown-bilibili"
    _battery = [_netease, _qqmusic, _ytmusic, _bilibili]

    if build.with? "battery"
      _plugins = _plugins + _battery
    else
      if build.with? "netease"
        _plugins.push(_netease)
      end
      if build.with? "qqmusic"
        _plugins.push(_qqmusic)
      end
      if build.with? "ytmusic"
        _plugins.push(_ytmusic)
      end
      if build.with? "bilibili"
        _plugins.push(_bilibili)
      end
    end

    pip_args = []
    pypi_mirrors = {
      "tsinghua-pypi" => "https://pypi.tuna.tsinghua.edu.cn/simple",
      "aliyun-pypi" => "https://mirrors.aliyun.com/pypi/simple",
      "douban-pypi" => "https://pypi.douban.com/simple"
    }
    selected_mirrors = pypi_mirrors.select { |name, _url| build.with? name }
    if selected_mirrors.length > 1
      odie "Only one mirror can be specified: --tsinghua-pypi, --aliyun-pypi, --douban-pypi"
    end
    if selected_mirrors.any?
      pip_args += ["-i", selected_mirrors.values.first]
    end

    virtualenv_create(libexec, "python3.11")
    system libexec/"bin"/"python3", "-m", "pip", "install", *pip_args, "#{buildpath}[macos,ai,cookies,webengine]"
    if _plugins.any?
      system libexec/"bin"/"python3", "-m", "pip", "install", *pip_args, *_plugins
    end
    bin.install Dir[libexec/"bin/feeluown"]
    bin.install Dir[libexec/"bin/fuo"]
  end

  def caveats
    <<-EOF
    You can also use pip to install/uninstall plugins since FeelUOwn
    is installed into a virtual env. So you can run the following cmd

      '#{libexec/"bin"/"pip"} install/uninstall fuo-qqmusic'

    to install/uninstall 'fuo-qqmusic' plugin.

    If you install from mainland China, you can enable mirror source:

      brew install feeluown --tsinghua-pypi
      brew install feeluown --aliyun-pypi
      brew install feeluown --douban-pypi
    EOF
  end

  test do
    system bin/"fuo", "--help"
    system bin/"feeluown", "--help"
  end
end
