# asciinema.fish - Asciinema Recording and GIF Conversion Utility

This is a `fish` shell function that wraps the `asciinema` command, providing extended functionality, primarily for converting `asciinema` recordings into animated GIFs using `agg`.

## Features

*   **Seamless GIF Conversion:** Easily record your terminal sessions and convert them directly to high-quality GIFs.
*   **Dependency Checks:** Automatically checks for `asciinema` and `agg` installations.
*   **Intelligent Font Handling:** Attempts to automatically locate common font directories across different operating systems (Linux, macOS, Windows, Termux) to ensure your GIFs look great.
*   **`agg` Option Passthrough:** Supports passing all `agg` options directly for fine-grained control over GIF generation (e.g., `--font-size`, `--theme`, `--fps-cap`).
*   **Termux Integration:** Provides specific hints for Termux users regarding font installation (`tty-dejavu`).

## Dependencies

Before using this function, ensure you have the following tools installed:

*   **`asciinema`**: For recording terminal sessions.
    *   Installation instructions: [https://asciinema.org/docs/installation](https://asciinema.org/docs/installation)
*   **`agg`**: For converting `asciinema` recordings to GIFs.
    *   Installation instructions: [https://github.com/asciinema/agg](https://github.com/asciinema/agg) (usually involves `cargo install agg` if you have Rust installed).

## Installation

### Installation via Oh My Fish

If you use [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish), you can install this plugin directly:

```bash
omf install https://github.com/mzyui/omf-plugin-asciinema-gif
```

### Manual Installation

1.  Clone this repository to your local machine:

    ```bash
    git clone https://github.com/mzyui/omf-plugin-asciinema-gif.git ~/.config/omf/bundle/omf-plugin-asciinema-gif # Or any other preferred location
    ```

2.  Restart your `fish` shell or run `fish_update_completions` to load the new function.

## Usage

### Basic `asciinema` Commands

You can use `asciinema` as you normally would. This function acts as a transparent wrapper:

```bash
asciinema rec
asciinema play <cast_file>
asciinema upload <cast_file>
# etc.
```

### Recording and Converting to GIF

To record a session and convert it directly to a GIF:

```bash
basciinema gif output.gif
```

This will start an `asciinema` recording session. Once you are done, type `exit` or press `Ctrl-D`. The script will then automatically convert the recording to `output.gif`.

### Using `agg` Options

You can pass any `agg` options after the output GIF filename:

```bash
asciinema gif my_session.gif --font-size 18 --theme dracula --idle-time-limit 2
```

For a full list of `agg` options, run:

```bash
asciinema gif --help
```

### Termux Specifics

If you are a Termux user, consider installing the `tty-dejavu` font for better visual appearance in your GIFs:

```bash
pkg install tty-dejavu
```

## License

This project is licensed under the MIT License - see the LICENSE file for details (if you create one).
