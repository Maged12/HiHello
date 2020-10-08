import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditFormField extends StatelessWidget {
  EditFormField({
    this.onValidation,
    this.onSave,
    this.type,
    this.hint,
    this.icon,
    this.data,
  });
  final String Function(String val) onValidation;
  final void Function(String val) onSave;
  final TextInputType type;
  final String hint;
  final IconData icon;
  final TextEditingController data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: data,
        validator: (val) => onValidation(val),
//        onFieldSubmitted:(val){
//
//        },
//        onChanged: (val){
//
//        },
        toolbarOptions: ToolbarOptions(
          copy: true,
          paste: true,
          selectAll: true,
        ),
        //keyboardAppearance: Brightness.light,
        enableSuggestions: false,
        textCapitalization: hint == 'About'
            ? TextCapitalization.sentences
            : TextCapitalization.words,
        keyboardType: type,
        maxLines: data.text.length > 25 ? 4 : 1,
        maxLength: hint == 'About' ? 350 : null,
        style: GoogleFonts.aclonica(),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).accentColor,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),
        ),
        onSaved: (val) => onSave(val),
      ),
    );
  }
}
