from neovim import attach


def cleanup(nvim):
    nvim.command('bd!')


def startNvim():
    nvim = attach("socket", path="/tmp/nvim")
    nvim.command("PlugInstall")
    cleanup(nvim)
    return nvim
