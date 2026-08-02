class Caude < Formula
  desc "Menu bar app showing Claude Code's 5-hour/weekly usage windows"
  homepage "https://github.com/KarlinskyS/caude-o-clock"
  url "https://github.com/KarlinskyS/caude-o-clock.git", tag: "v1.0.3", revision: "b69881a716831e0741d7c14db66b416a1c4f93bf", using: :git

  depends_on :macos
  depends_on "python@3.12"

  def install
    libexec.install Dir["*.py"]
    libexec.install "assets"
    libexec.install "requirements.txt"
    libexec.install "caude"

    system formula_opt_bin("python@3.12")/"python3.12", "-m", "venv", libexec/".venv"
    system libexec/".venv/bin/pip", "install", "--quiet", "-r", libexec/"requirements.txt"

    (bin/"caude").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/caude" "$@"
    EOS
    (bin/"caude").chmod 0755
  end

  test do
    assert_path_exists libexec/".venv/bin/python3"
    assert_path_exists libexec/"ccusagebar.py"
    system bin/"caude", "--help"
  end
end
