class Feeluown < Formula
  include Language::Python::Virtualenv

  desc "A user-friendly and hackable music player"
  homepage "https://github.com/feeluown/"
  url "https://files.pythonhosted.org/packages/27/c7/4b990a4ad1a467366faab706a406f83de548470e81cc572e71d2e659a3fd/feeluown-4.1.5.tar.gz"
  sha256 "4f0856144a7c178fe49c9d6155306cf11637fdf7c23f9fd404754b94b46c47bc"

  depends_on "python@3.11"
  depends_on "pyqt5"
  depends_on "mpv"

  option "with-battery", "feeluown battery"
  option "with-qqmusic", "feeluown qqmusic plugin"
  # option "with-kuwo", "feeluown kuwo plugin"
  option "with-netease", "feeluown netease plugin"
  option "with-ytmusic", "feeluown ytmusic plugin"
  option "with-bilibili", "feeluown bilibili plugin"

  def install
    _plugins = []
    _netease = "fuo-netease"
    _qqmusic = "fuo-qqmusic"
    _kuwo = "fuo-kuwo"
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
      if build.with? "kuwo"
        _plugins.push(_kuwo)
      end
      if build.with? "ytmusic"
        _plugins.push(_ytmusic)
      end
      if build.with? "bilibili"
        _plugins.push(_bilibili)
      end
    end

    venv = virtualenv_create(libexec, "python3.11")
    system libexec/"bin"/"python3", "-m", "pip", "install", buildpath/"[macos]"
    if _plugins
      system libexec/"bin"/"python3", "-m", "pip", "install", *_plugins
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
    EOF
  end

  test do
    system bin/"fuo", "--help"
    system bin/"feeluown", "--help"
  end
end
