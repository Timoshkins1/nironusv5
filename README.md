

#Neironus
Это только Демо версия для андроид
**Neironus** is an application for generating images based on textual prompts. Users can input textual prompts in Russian, which are then translated into English and used to generate images using the Pollinations API. The application also includes a chat feature with God, where users can send messages and receive responses using the Pollinations API for text generation.

## Key Features:

1. **Image Generation**:
   - Users can input textual prompts in Russian.
   - Prompts are translated into English using the Yandex Translate API.
   - Images are generated based on the translated prompts using the Pollinations API.
   - Users can specify image parameters such as width, height, and the number of images.

2. **Chat with God**:
   - Users can send messages and receive responses using the Pollinations API for text generation.
   - The conversation history is saved and displayed in a list view.

## How to Use:

1. **Image Generation**:
   - Open the application and navigate to the main screen.
   - Enter a textual prompt in Russian in the input field.
   - Specify image parameters such as width, height, and the number of images.
   - Click the "Generate Images" button to generate images.
   - The generated images are displayed on the screen.

2. **Chat with God**:
   - Navigate to the chat screen by clicking the "Chat with God" button.
   - Enter your message in the input field and click the "Send" button.
   - The response from God is displayed in the list of messages.
   - The conversation history is saved and displayed in a list view.

## Technical Details:

- **Platform**: Flutter
- **APIs**: Yandex Translate API, Pollinations API
- **Libraries**: http, logger

## Setup and Configuration:

1. **Install Dependencies**:
   - Open the `pubspec.yaml` file and add the following dependencies:
     ```yaml
     dependencies:
       flutter:
         sdk: flutter
       http: ^0.13.3
       logger: ^1.1.0
     ```
   - Run the command to install the dependencies:
     ```bash
     flutter pub get
     ```

2. **Configure API Keys**:
   - Replace `YOUR_YANDEX_TRANSLATE_API_KEY` with your Yandex Translate API key in the `lib/main.dart` file.

## Conclusion:

The Neironus application provides a convenient way to generate images based on textual prompts and engage in conversations with God through textual messages. It leverages modern technologies and APIs to deliver a high-quality user experience.
