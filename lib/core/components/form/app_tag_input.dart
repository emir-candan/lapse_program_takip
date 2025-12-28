import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'app_text_input.dart';
import '../../theme/app_theme.dart';

class AppTagInput extends StatefulWidget {
  final List<String> initialTags;
  final ValueChanged<List<String>>? onTagsChanged;
  final String hintText;

  const AppTagInput({
    super.key,
    this.initialTags = const [],
    this.onTagsChanged,
    this.hintText = "Etiket ekle...",
  });

  @override
  State<AppTagInput> createState() => _AppTagInputState();
}

class _AppTagInputState extends State<AppTagInput> {
  late List<String> _tags;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.initialTags);
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _controller.clear();
      });
      widget.onTagsChanged?.call(_tags);
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
    widget.onTagsChanged?.call(_tags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppTheme.tokens.tagSpacing,
          runSpacing: AppTheme.tokens.tagSpacing,
          children: _tags.map((tag) => MoonChip(
            label: Text(tag),
            onTap: () => _removeTag(tag),
            backgroundColor: context.moonColors?.roshi.withOpacity(0.1),
            textColor: context.moonColors?.roshi,
            leading: Icon(Icons.close, size: AppTheme.tokens.tagIconSize),
          )).toList(),
        ),
        if (_tags.isNotEmpty) SizedBox(height: AppTheme.tokens.tagSpacing),
        AppTextInput(
          controller: _controller,
          hintText: widget.hintText,
          prefixIcon: Icons.tag,
          onFieldSubmitted: _addTag,
        ),
      ],
    );
  }
}
