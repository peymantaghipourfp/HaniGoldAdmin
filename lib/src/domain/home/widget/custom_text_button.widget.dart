import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/config/const/app_color.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';

class CustomTextButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColor.secondaryColor,
  });

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  bool isHovered = false;
  bool isFocused = false;

  void handleHover(bool hovering) {
    setState(() {
      isHovered = hovering;
    });
  }

  void handleFocus(bool focused) {
    setState(() {
      isFocused = focused;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: handleFocus,
      child: MouseRegion(
        onEnter: (_)=>handleHover(true),
        onExit: (_)=>handleHover(false),
        child: TextButton(
            style: ButtonStyle(elevation: WidgetStateProperty.all(5),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                  side: BorderSide(width: 1,color: AppColor.secondaryColor),
              ),
              ),
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (state){
                    if(state.contains(WidgetState.focused) || isHovered || isFocused){
                      return AppColor.backGroundColor;
                    }
                    return AppColor.secondaryColor;
                  }
              ),
            ),
              onPressed: widget.onPressed,
              child: Text(widget.text,style: AppTextStyle.bodyText,textAlign: TextAlign.right,),
          ),
      ),
    );

  }
}
