class Feeluown < Formula
  include Language::Python::Virtualenv

  desc "A user-friendly and hackable music player"
  homepage "https://github.com/feeluown/"
  url "https://files.pythonhosted.org/packages/3a/b6/0d3edeab6f2cd07b5d351ef2cac74d2890f30da49c3adf0e35e9fa23e527/feeluown-3.8.12.tar.gz"
  sha256 "28fd2620081863ce97451ef3fae6004c1d0d78ac075cd5202b4f71434c723e8a"

  depends_on "python@3.10"
  depends_on "pyqt5"
  depends_on "mpv"

  option "with-battery", "feeluown battery"
  option "with-qqmusic", "feeluown qqmusic plugin"
  option "with-kuwo", "feeluown kuwo plugin"
  option "with-netease", "feeluown netease plugin"
  option "with-bilibili", "feeluown bilibili plugin"

  def install
    _plugins = []
    _netease = "fuo-netease"
    _qqmusic = "fuo-qqmusic"
    _kuwo = "fuo-kuwo"
    _bilibili = "feeluown-bilibili"
    _battery = [_netease, _qqmusic, _kuwo, _bilibili]

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
      if build.with? "bilibili"
        _plugins.push(_bilibili)
      end
    end

    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin"/"pip", "install", buildpath/"[macos]"
    if _plugins
      system libexec/"bin"/"pip", "install", *_plugins
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
