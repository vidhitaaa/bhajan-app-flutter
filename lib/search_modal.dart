import 'package:flutter/material.dart';

class SearchModal extends StatelessWidget {
  final Function(int)? onOkPressed;
  final TextEditingController controller = TextEditingController();

  SearchModal({Key? key, this.onOkPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter a Number'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Please enter a number:'),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter a number',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a number';
              }
              int? enteredNumber = int.tryParse(value);
              if (enteredNumber == null ||
                  enteredNumber < 1 ||
                  enteredNumber > 100) {
                return 'Please enter a number between 1 and 100';
              }
              return null;
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Validate the entered number
            if (controller.text.isNotEmpty) {
              int? enteredNumber = int.tryParse(controller.text);
              if (enteredNumber != null &&
                  enteredNumber >= 1 &&
                  enteredNumber <= 100) {
                // Call onOkPressed callback with the entered number
                onOkPressed?.call(enteredNumber);
                Navigator.pop(context); // Close the modal
                return;
              }
            }
            // Show error message if validation fails
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter a number between 1 and 100.'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
