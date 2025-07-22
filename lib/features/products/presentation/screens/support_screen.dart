import 'package:atomic_design_system/widgets/faq_item.dart';
import 'package:atomic_design_system/widgets/helper_card.dart';
import 'package:atomic_design_system/widgets/helper_header.dart';
import 'package:ecommerce/core/widgets/screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atomic_design_system/atoms/appbars/generic_app_bar.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ScreenWidget(
      hasBottomNavigationBar: true,
      appBar: GenericAppBar(title: 'Soporte y Contacto'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          HelperHeader(),
          const SizedBox(height: 32),

          // Sección de contacto
          Text(
            'Contacto directo',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          HelperCard(
            icon: Icons.email,
            title: 'Correo electrónico',
            subtitle: 'Envíanos un mensaje directamente',
            value: 'soporte@fakestore.com',
          ),
          const SizedBox(height: 12),
          HelperCard(
            icon: Icons.phone,
            title: 'Teléfono',
            subtitle: 'Horario: L-V 9:00 a 18:00',
            value: '+1 234 567 890',
          ),
          const SizedBox(height: 12),
          HelperCard(
            icon: Icons.location_on,
            title: 'Oficinas',
            subtitle: 'Visítanos en nuestras instalaciones',
            value: 'Calle Falsa 123, Ciudad',
          ),
          const SizedBox(height: 32),

          // Preguntas frecuentes
          Text(
            'Preguntas frecuentes',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          FaqItem(
            question: '¿Cómo realizo un pedido?',
            answer:
                'Puedes agregar productos al carrito desde el catálogo y proceder al checkout.',
          ),
          FaqItem(
            question: '¿Cuáles son los métodos de pago?',
            answer:
                'Aceptamos tarjetas de crédito/débito, PayPal y transferencias bancarias.',
          ),
          FaqItem(
            question: '¿Cuánto tarda el envío?',
            answer:
                'El envío estándar tarda 3-5 días hábiles. Ofrecemos opción express (24h) con costo adicional.',
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
