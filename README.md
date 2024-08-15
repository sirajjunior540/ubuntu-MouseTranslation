
# Mouse Translation Tool

Mouse Translation Tool is a lightweight application designed to translate clipboard text on-the-fly. 
It uses the Google Translate API to perform translations and displays the translated text near your mouse pointer. 
This app is particularly useful for those who frequently need to translate snippets of text while browsing or working with documents.

## Features
- **Automatic Translation:** Copies text to your clipboard and it’s automatically translated.
- **Language Choice:** Select your desired target language from a list.
- **Real-time Notifications:** The translation appears near your mouse cursor.
- **Background Operation:** Runs silently in the background with a tray icon for easy access.

## Installation

   ```bash
    # Download the .deb file using curl
    curl -L -o MouseTranslation-v1.deb https://github.com/sirajjunior540/ubuntu-MouseTranslation/raw/master/MouseTranslation-v1.deb

    # Install the .deb file using dpkg
    sudo dpkg -i ./MouseTranslation-v1.deb

   ```

### Prerequisites
Before installing the Mouse Translation Tool, ensure you have the following dependencies installed on your system:

- Bash
- `xdotool`
- `xclip`
- `zenity`
- Python 3
- `pystray` (Python library)
- `PIL` (Python Imaging Library)
- `jq`

### Setup

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/mousetranslation.git
   cd mousetranslation
   ```

2. **API Key Setup:**
   - Obtain your Google Translate API key from the Google Cloud Console.
   - If you don't have an API key, navigate to this page and get one: [Google Cloud Translate](https://cloud.google.com/translate)
   - Run the following script to configure your API key:
     ```bash
     #!/bin/bash
     echo "Enter your Google Translate API Key:"
     echo "If you don't have an API key, navigate to this page to get one: https://cloud.google.com/translate"
     read API_KEY
     sed -i "s|<YOUR_API_KEY>|$API_KEY|g" /usr/bin/mousetranslation.sh
     pip install pystray
     ```

3. **Make the Script Executable:**
   ```bash
   chmod +x mousetranslation.sh
   ```

4. **Run the Application:**
   ```bash
   ./mousetranslation.sh
   ```

## Usage

1. **Select Target Language:**
   - Upon running the script, a dialog box will prompt you to select the target language for translation.

2. **Clipboard Monitoring:**
   - The app monitors your clipboard for any new text. As soon as you copy text, it gets translated automatically.

3. **View Translations:**
   - The translated text will be shown as a notification.

4. **Tray Icon:**
   - The app will create a tray icon for easy access and control. You can exit the app by clicking "Quit" from the tray icon's menu.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contributing
Contributions are welcome! Please fork the repository and submit a pull request with your changes.

## Troubleshooting
If you encounter any issues, please check the following:
- Ensure all dependencies are installed.
- Verify your API key is correctly set in the script.
- Check internet connectivity as the translation requires online access.

For further assistance, feel free to open an issue on the GitHub repository.