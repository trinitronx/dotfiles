# .files

> 🔧 My dotfiles OS agnostic

## Usage

See [`chezmoi` official documentation](https://www.chezmoi.io/)

If you're not using `chezmoi`, you can simply copy and modify whatever
individual files you need, and adapt the filenames, because it uses it's own
[file naming scheme][1].

For example:
- `private_dot_local` maps to `~/.local`
- `private_dot_local/private_share` maps to `~/.local/share`
- `dot_config` maps to `~/.config`
- Some file named `executable_foo.sh` gets renamed to `foo.sh`
and made executable (e.g. `chmod +x foo.sh`)

## License

AGPLv3 © James Cuzella [@trinitronx](https://github.com/trinitronx)

See [LICENSE](./LICENSE)

[1]: https://www.chezmoi.io/user-guide/frequently-asked-questions/design/#why-does-chezmoi-use-weird-filenames

