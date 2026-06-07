import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class OrderModel {
  final String id;
  final String orderNumber;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String customerAddress;
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double discount;
  final double total;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String? deliveryPartner;
  final String? trackingId;
  final String? notes;
  final String? cancellationReason;
  final String? returnReason;
  final String? returnStatus;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.customerAddress,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.orderDate,
    this.deliveryDate,
    this.deliveryPartner,
    this.trackingId,
    this.notes,
    this.cancellationReason,
    this.returnReason,
    this.returnStatus,
  });

  OrderModel copyWith({
    String? id,
    String? orderNumber,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? customerAddress,
    List<OrderItem>? items,
    double? subtotal,
    double? tax,
    double? deliveryFee,
    double? discount,
    double? total,
    String? paymentMethod,
    String? paymentStatus,
    String? orderStatus,
    DateTime? orderDate,
    DateTime? deliveryDate,
    String? deliveryPartner,
    String? trackingId,
    String? notes,
    String? cancellationReason,
    String? returnReason,
    String? returnStatus,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryPartner: deliveryPartner ?? this.deliveryPartner,
      trackingId: trackingId ?? this.trackingId,
      notes: notes ?? this.notes,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      returnReason: returnReason ?? this.returnReason,
      returnStatus: returnStatus ?? this.returnStatus,
    );
  }
}

class OrderItem {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double price;
  final double total;
  final Map<String, String>? customizations;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
    required this.total,
    this.customizations,
  });
}

enum OrderStatus {
  newOrder('New', Iconsax.add_circle, Colors.orange),
  processing('Processing', Iconsax.refresh, Colors.blue),
  completed('Completed', Iconsax.tick_circle, Colors.green),
  cancelled('Cancelled', Iconsax.close_circle, Colors.red),
  returned('Returned', Iconsax.arrow_left, Colors.purple);

  final String label;
  final IconData icon;
  final Color color;

  const OrderStatus(this.label, this.icon, this.color);
}

enum PaymentStatus {
  pending('Pending', Colors.orange),
  paid('Paid', Colors.green),
  failed('Failed', Colors.red),
  refunded('Refunded', Colors.purple);

  final String label;
  final Color color;

  const PaymentStatus(this.label, this.color);
}
