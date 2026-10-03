import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../../models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive.dart';
import '../../router/app_router.dart';

class ReportScreen extends StatefulWidget {
  final bool isLost;
  const ReportScreen({super.key, required this.isLost});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();
  ItemCategory _category = ItemCategory.other;
  bool _submitted = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _submitted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.horizontalPadding(context);
    final title =
        widget.isLost ? 'Report a Lost Item' : 'Report a Found Item';
    final subtitle = widget.isLost
        ? 'Fill in the details below and we will help reunite you with your item.'
        : 'Let the owner know you found their item. Provide as much detail as possible.';

    return Scaffold(
      appBar: AppNavBar(
        currentRoute:
            widget.isLost ? AppRoutes.reportLost : AppRoutes.reportFound,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: pad,
          vertical: AppConstants.spacingXl,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: _submitted ? _buildSuccess() : _buildForm(title, subtitle),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(String title, String subtitle) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppTypography.textTheme.bodyLarge
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          _buildField(
            'Item Title *',
            _titleController,
            hint: 'e.g. Black Sony Headphones',
          ),
          const SizedBox(height: 16),
          _buildField(
            'Description *',
            _descController,
            hint: 'Describe the item, any markings, contents, etc.',
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          _buildField(
            'Last known / found location *',
            _locationController,
            hint: 'e.g. Main Library, 2nd Floor',
          ),
          const SizedBox(height: 16),
          _buildCategoryDropdown(),
          const SizedBox(height: 16),
          _buildField(
            'Your Email (optional)',
            _contactController,
            hint: 'so the finder/owner can contact you',
            keyboardType: TextInputType.emailAddress,
            required: false,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              child: Text(
                widget.isLost
                    ? 'Submit Lost Report'
                    : 'Submit Found Report',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    String hint = '',
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool required = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.textTheme.titleSmall),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint),
          validator: required
              ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
              : null,
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category *', style: AppTypography.textTheme.titleSmall),
        const SizedBox(height: 6),
        DropdownButtonFormField<ItemCategory>(
          value: _category,
          decoration: const InputDecoration(),
          items: ItemCategory.values
              .map(
                (c) => DropdownMenuItem(
                  value: c,
                  child: Text('${c.icon}  ${c.label}'),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _category = v!),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: AppColors.successLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: AppColors.success, size: 40),
        ),
        const SizedBox(height: 24),
        Text(
          'Report Submitted!',
          style: AppTypography.textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Text(
          widget.isLost
              ? 'Your lost item report has been submitted. We will notify you when a match is found.'
              : 'Thank you for reporting a found item. The community appreciates your honesty!',
          style: AppTypography.textTheme.bodyLarge
              ?.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => setState(() {
            _submitted = false;
            _titleController.clear();
            _descController.clear();
            _locationController.clear();
            _contactController.clear();
          }),
          child: const Text('Submit Another'),
        ),
      ],
    );
  }
}
