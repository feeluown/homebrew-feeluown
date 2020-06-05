class Feeluown < Formula
  desc "A user-friendly and hackable music player"
  homepage "https://github.com/feeluown/"
  url "https://files.pythonhosted.org/packages/d6/b9/0329ae2253ce5cb634f50da8a8ff5ca6399d44a4785c4159299cd2193dc9/feeluown-3.5a0.tar.gz"
  sha256 "434599e87ecc77015be1ab800b23ddc53ea73ace7474773173ef0d6ea87101cf"
  bottle :unneeded

  depends_on "python@3.8"
  depends_on "pyqt5"
  depends_on "mpv"

  option "with-battery", "feeluown battery"

  def install
    _extra = "[macos]"
    if build.with? "battery"
      _extra = "[battery,macos]"
    end
    _package = "#{buildpath}/#{_extra}"

    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system Formula["python@3.8"].opt_bin/"pip3", "install", _package,
           "--upgrade", "--prefix", libexec

    bin.install Dir[libexec/"bin/feeluown"]
    bin.install Dir[libexec/"bin/fuo"]
    bin.install Dir[libexec/"bin/feeluown-genicon"]

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"fuo", "--help"
    system bin/"feeluown", "--help"
  end
end
