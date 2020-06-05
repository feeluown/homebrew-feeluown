class Feeluown < Formula
  include Language::Python::Virtualenv

  desc "A user-friendly and hackable music player"
  homepage "https://github.com/feeluown/"
  url "https://files.pythonhosted.org/packages/d6/b9/0329ae2253ce5cb634f50da8a8ff5ca6399d44a4785c4159299cd2193dc9/feeluown-3.5a0.tar.gz"
  sha256 "434599e87ecc77015be1ab800b23ddc53ea73ace7474773173ef0d6ea87101cf"
  bottle :unneeded

  depends_on "python3"
  depends_on "pyqt5"
  depends_on "mpv"

  #
  # feeluown dependencies
  #
  resource "janus" do
    url "https://files.pythonhosted.org/packages/9a/76/fbb89aa5d3cb5f3fec6ce74d34cf980ccd475b015d1a59cb5a14fe4cd2c5/janus-0.5.0.tar.gz"
    sha256 "0700f5537d076521851d19b7625545c5e76f6d5792ab17984f28230adcc3b34c"
  end

  resource "qasync" do
    url "https://files.pythonhosted.org/packages/c0/88/92a02e43dd5eea9aa78ff1dd6d5899f3626e224f54a253eedc1115650fa7/qasync-0.9.4.tar.gz"
    sha256 "3780c332fa12bb21e479aea871ca770ab892c211182f72e7b9e558060548e93e"
  end

  # requests dependencies
  resource "requests" do
    url "https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915/requests-2.23.0.tar.gz"
    sha256 "b3f43d496c6daba4493e7c431722aeb7dbc6288f52a6e04e7b6023b0247817e6"
  end
  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b8/e2/a3a86a67c3fc8249ed305fc7b7d290ebe5e4d46ad45573884761ef4dea7b/certifi-2020.4.5.1.tar.gz"
    sha256 "51fcb31174be6e6664c5f69e3e1691a2d72a1a12e90f872cbdb1567eb47b6519"
  end
  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/05/8c/40cd6949373e23081b3ea20d5594ae523e681b6f472e600fbc95ed046a36/urllib3-1.25.9.tar.gz"
    sha256 "3018294ebefce6572a474f0604c2021e33b3fd8006ecd11d62107a5d2a963527"
  end
  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
    sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
  end
  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "pyopengl" do
    url "https://files.pythonhosted.org/packages/b8/73/31c8177f3d236e9a5424f7267659c70ccea604dab0585bfcd55828397746/PyOpenGL-3.1.5.tar.gz"
    sha256 "4107ba0d0390da5766a08c242cf0cf3404c377ed293c5f6d701e457c57ba3424"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"fuo", "--help"
    system bin/"feeluown", "--help"
  end
end
