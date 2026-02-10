
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CustomOtpBox extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  
  const CustomOtpBox({
    super.key,
    this.onChanged,
  });

  @override
  State<CustomOtpBox> createState() => _CustomOtpBoxState();
}

class _CustomOtpBoxState extends State<CustomOtpBox> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    for (var node in _focusNodes) {
      node.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateOtp() {
    String otp = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(otp);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (index) {
        return SizedBox(
          width: w * .175,
          height: w * .22,
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textInputAction: index < 3
                ? TextInputAction.next
                : TextInputAction.done,
            onFieldSubmitted: (value) {
              if (index == 3) {
                String otp = _controllers.map((c) => c.text).join();
                if (otp.length == 4) {
                  //!  CustomNavigation.push(context, CustomBottomNavBar());
                }
              }
            },
            onChanged: (value) {
              if (value.length == 1 && index < 3) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              }
              _updateOtp(); // Call onChanged when any digit changes
            },
            style: TextStyle(fontSize: w * .08, fontWeight: FontWeight.w500),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: w * .04),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(w * .04),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorsList.mainButtonColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(w * .04),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _controllers[index].text.isNotEmpty
                      ? ColorsList.mainButtonColor
                      : Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(w * .04),
              ),
            ),
            cursorHeight: w * .08,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        );
      }),
    );
  }
}