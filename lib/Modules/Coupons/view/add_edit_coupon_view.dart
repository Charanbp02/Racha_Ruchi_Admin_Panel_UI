// lib/Modules/Coupons/view/add_edit_coupon_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racha_ruchi_admin_panel/Data/Models/Coupons_Model/coupons_models.dart';
import 'package:racha_ruchi_admin_panel/Modules/Coupons/controller/admin_coupons_controller.dart';

class AddEditCouponView extends StatefulWidget {
  final CouponModel? coupon;
  const AddEditCouponView({super.key, this.coupon});

  @override
  State<AddEditCouponView> createState() => _AddEditCouponViewState();
}

class _AddEditCouponViewState extends State<AddEditCouponView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController codeController;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController discountController;
  late TextEditingController minOrderController;
  late TextEditingController maxDiscountController;
  late TextEditingController usageLimitController;

  late CouponType selectedType;
  late DateTime selectedDate;
  late int usageLimit;

  final AdminCouponsController controller = Get.find();

  @override
  void initState() {
    super.initState();

    codeController = TextEditingController(text: widget.coupon?.code ?? '');
    titleController = TextEditingController(text: widget.coupon?.title ?? '');
    descriptionController = TextEditingController(
      text: widget.coupon?.description ?? '',
    );
    discountController = TextEditingController(
      text: widget.coupon?.discount ?? '',
    );
    minOrderController = TextEditingController(
      text: widget.coupon?.minOrder.toString() ?? '',
    );
    maxDiscountController = TextEditingController(
      text: widget.coupon?.maxDiscount.toString() ?? '',
    );
    usageLimitController = TextEditingController(
      text: widget.coupon?.usageLimit.toString() ?? '100',
    );

    selectedType = widget.coupon?.type ?? CouponType.percentage;
    selectedDate =
        widget.coupon?.validTill ??
        DateTime.now().add(const Duration(days: 30));
    usageLimit = widget.coupon?.usageLimit ?? 100;
  }

  @override
  void dispose() {
    codeController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    discountController.dispose();
    minOrderController.dispose();
    maxDiscountController.dispose();
    usageLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          widget.coupon == null ? 'Create Coupon' : 'Edit Coupon',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTextField(
                codeController,
                'Coupon Code',
                Iconsax.code,
                validator: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                titleController,
                'Title',
                Iconsax.tag,
                validator: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                descriptionController,
                'Description',
                Iconsax.document_text,
                maxLines: 3,
                validator: true,
              ),
              const SizedBox(height: 16),

              // Coupon Type
              _buildTypeSelector(),
              const SizedBox(height: 16),

              _buildTextField(
                discountController,
                'Discount Value',
                Iconsax.discount_circle,
                validator: true,
                hint:
                    selectedType == CouponType.percentage
                        ? 'e.g., 20%'
                        : 'e.g., ₹100',
              ),
              const SizedBox(height: 16),

              _buildTextField(
                minOrderController,
                'Minimum Order (₹)',
                Iconsax.money,
                keyboardType: TextInputType.number,
                validator: true,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                maxDiscountController,
                'Maximum Discount (₹)',
                Iconsax.discount_shape,
                keyboardType: TextInputType.number,
                validator: true,
              ),
              const SizedBox(height: 16),

              // Valid Till Date
              _buildDateSelector(),
              const SizedBox(height: 16),

              _buildTextField(
                usageLimitController,
                'Usage Limit',
                Iconsax.filter,
                keyboardType: TextInputType.number,
                validator: true,
              ),
              const SizedBox(height: 32),

              // Submit Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        controller.isLoading.value
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              widget.coupon == null
                                  ? 'Create Coupon'
                                  : 'Update Coupon',
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool validator = false,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator:
          validator ? (v) => v == null || v.isEmpty ? 'Required' : null : null,
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Coupon Type',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children:
              CouponType.values.map((type) {
                final isSelected = selectedType == type;
                return FilterChip(
                  label: Text(type.displayName),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedType = type;
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: Colors.blue.shade100,
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Valid Till', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              setState(() {
                selectedDate = date;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.calendar),
                const SizedBox(width: 12),
                Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (widget.coupon == null) {
        controller.createCoupon(
          code: codeController.text,
          title: titleController.text,
          description: descriptionController.text,
          discount: discountController.text,
          minOrder: double.parse(minOrderController.text),
          maxDiscount: double.parse(maxDiscountController.text),
          validTill: selectedDate,
          type: selectedType,
          usageLimit: int.parse(usageLimitController.text),
        );
      } else {
        final updatedCoupon = CouponModel(
          id: widget.coupon!.id,
          code: codeController.text,
          title: titleController.text,
          description: descriptionController.text,
          discount: discountController.text,
          minOrder: double.parse(minOrderController.text),
          maxDiscount: double.parse(maxDiscountController.text),
          validTill: selectedDate,
          type: selectedType,
          usedOn: widget.coupon!.usedOn,
          isNew: widget.coupon!.isNew,
          isTrending: widget.coupon!.isTrending,
          isExpired: widget.coupon!.isExpired,
          isEnabled: widget.coupon!.isEnabled,
          usageLimit: int.parse(usageLimitController.text),
          usedCount: widget.coupon!.usedCount,
          createdAt: widget.coupon!.createdAt,
          updatedAt: DateTime.now(),
        );
        controller.updateCoupon(updatedCoupon);
      }
    }
  }
}
