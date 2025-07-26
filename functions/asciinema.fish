# functions/asciinema.fish
#
# fish function wrapper for asciinema, with extended functionality to create gifs.
#
function asciinema --description "Asciinema recording and GIF conversion utility"
    # --- Dependency Checks ---
    if not command -v asciinema >/dev/null
        echo "Error: 'asciinema' is not installed. Please install it first." >&2
        return 1
    end

    if not command -v agg >/dev/null
        echo "Error: 'agg' is not installed. Please install it to use GIF conversion." >&2
        return 1
    end

    # --- Help Logic ---
    if test (count $argv) -eq 0; or string match -q -- "-h" $argv[1]; or string match -q -- "--help" $argv[1]
        # Show default asciinema help
        command asciinema --help
        echo ""
        echo (set_color -o)"example usage (gif extension):"(set_color normal)
        echo "  Record a session and convert it to a GIF:"
        echo "    "(set_color -o)"asciinema gif output.gif"(set_color normal)
        echo "  For more gif options, run:"
        echo "    "(set_color -o)"asciinema gif --help"(set_color normal)

        # Hint for Termux users to install tty-dejavu
        if test -n "$PREFIX"
            echo ""
            echo "Termux users:"
            echo "   For a common and visually appealing font in your GIFs, consider installing:"
            echo "     "(set_color -o)"pkg install tty-dejavu"(set_color normal)
        end
        return 0
    end

    # --- Main Command Logic ---
    switch $argv[1]
        case 'gif'
            if contains -- -h $argv; or contains -- --help $argv
                echo "Usage: asciinema gif <output.gif> [options]"
                echo ""
                echo "Records a terminal session and converts it to a GIF."
                echo ""
                echo (set_color -o)"Options:"(set_color normal)
                echo "  --cols <COLS>                    Override terminal width (number of columns)"
                echo "  --rows <ROWS>                    Override terminal height (number of rows)"
                echo "  --font-dir <FONT_DIR>            Use additional font directory"
                echo "  --font-family <FONT_FAMILY>      Specify font family [default: JetBrains Mono,Fira Code,SF Mono,Menlo,Consolas,DejaVu Sans Mono,Liberation Mono]"
                echo "  --font-size <FONT_SIZE>          Specify font size (in pixels) [default: 14]"
                echo "  --fps-cap <FPS_CAP>              Set FPS cap [default: 30]"
                echo "  --idle-time-limit <SECS>         Limit idle time to max number of seconds [default: 5]"
                echo "  --last-frame-duration <SECS>     Set last frame duration [default: 3]"
                echo "  --line-height <FLOAT>            Specify line height [default: 1.4]"
                echo "  --no-loop                        Disable animation loop"
                echo "  --renderer <RENDERER>            Select frame rendering backend [default: resvg] [possible values: resvg, fontdue]"
                echo "  --speed <FLOAT>                  Adjust playback speed [default: 1]"
                echo "  --theme <THEME>                  Select color theme [possible values: asciinema, dracula, github-dark, github-light, monokai, nord, solarized-dark, solarized-light, custom]"
                echo "  -v, --verbose                    Enable verbose logging"
                return 0
            end

            # --- Argument Parsing for 'gif' ---
            if test (count $argv) -lt 2; or string match -q -- '-*' $argv[2]
                echo "Error: Output GIF filename is required." >&2
                echo "Usage: asciinema gif <output.gif> [agg_options]" >&2
                return 1
            end

            set -l output_gif $argv[2]
            set -l agg_opts $argv[3..-1]
            set -l temp_cast_file (mktemp -u)".cast"

            # --- Recording ---
            echo "Starting recording. Press Ctrl-D or type 'exit' to finish."
            command asciinema rec "$temp_cast_file"

            if test $status -ne 0
                echo "Recording cancelled or failed." >&2
                rm -f "$temp_cast_file" # Clean up temp file on failure
                return 1
            end

            if not test -e "$temp_cast_file"
                echo "Recording failed, cast file not created." >&2
                return 1
            end

            # --- Conversion ---
            echo "Converting to GIF..."

            # --- Font Directory Logic (Cross-Platform) ---
            if not contains -- "--font-dir" $agg_opts
                set -l font_dir

                # Check for Termux environment first by checking for $PREFIX
                if test -n "$PREFIX" -a -d "$PREFIX/share/fonts/TTF"
                    set font_dir "$PREFIX/share/fonts/TTF"
                else
                    # Check for standard directories on other OSes
                    switch $OSTYPE
                        case Darwin # macOS
                            if test -d "$HOME/Library/Fonts"
                                set font_dir "$HOME/Library/Fonts"
                            end
                        case Linux
                            if test -d "$HOME/.local/share/fonts"
                                set font_dir "$HOME/.local/share/fonts"
                            else if test -d "/usr/share/fonts"
                                set font_dir "/usr/share/fonts"
                            end
                        case '*NT*'
                            # Windows (Cygwin, MSYS2, Git Bash)
                            if test -d "/mnt/c/Windows/Fonts"
                                set font_dir "/mnt/c/Windows/Fonts"
                            else if test -d "$LOCALAPPDATA/Microsoft/Windows/Fonts"
                                set font_dir "$LOCALAPPDATA/Microsoft/Windows/Fonts"
                            end
                    end
                end

                # If a valid font directory was found, add it to the options
                if test -n "$font_dir"
                    set -a agg_opts --font-dir "$font_dir"
                else
                    echo (set_color yellow)"Warning: No valid font directory found."(set_color normal) >&2
                end
            end

            # Add default theme if not specified
            if not contains -- "--theme" $agg_opts
                set -a agg_opts --theme asciinema
            end

            command agg $agg_opts "$temp_cast_file" "$output_gif"

            if test $status -eq 0
                echo "Successfully created "$output_gif""
                rm "$temp_cast_file"
            else
                echo "Failed to create GIF. Temporary cast file saved at: $temp_cast_file" >&2
                return 1
            end

        case '*'
            command asciinema $argv
    end
end
