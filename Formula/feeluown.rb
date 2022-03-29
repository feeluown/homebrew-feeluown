class Feeluown < Formula
  include Language::Python::Virtualenv

  desc "A user-friendly and hackable music player"
  homepage "https://github.com/feeluown/"
  url "https://files.pythonhosted.org/packages/f7/34/a26bbe19c06e99ce869ddfd2751b7f0632e2dbacfccfbd4f3ec7a3b53408/feeluown-3.8.4.tar.gz"
  sha256 "33241139b5f618eb2d05bd35c4db1577ee5ee4cb4eb9c64027bc8ce9ac351e66"

  depends_on "python@3.9"
  depends_on "pyqt5"
  depends_on "mpv"

  option "with-battery", "feeluown battery"
  option "with-qqmusic", "feeluown qqmusic plugin"
  option "with-kuwo", "feeluown kuwo plugin"
  option "with-netease", "feeluown netease plugin"
  option "with-local", "feeluown local plugin"

  def install
    _plugins = []
    _netease = "fuo-netease"
    _qqmusic = "fuo-qqmusic"
    _kuwo = "fuo-kuwo"
    _local = "fuo-local"
    _battery = [_netease, _qqmusic, _kuwo, _local]

    if build.with? "battery"
      _plugins = _plugins + _battery
    else
      if build.with? "netease"
        _plugins.push(_netease)
      end
      if build.with? "qqmusic"
        _plugins.push(_qqmusic)
      end
      if build.with? "local"
        _plugins.push(_local)
      end
      if build.with? "kuwo"
        _plugins.push(_kuwo)
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

  test do
    system bin/"fuo", "--help"
    system bin/"feeluown", "--help"
  end
end
