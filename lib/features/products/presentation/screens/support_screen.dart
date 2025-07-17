import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Soporte y Contacto'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Icon(Icons.help_outline, size: 60, color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    '¿Cómo podemos ayudarte?',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Estamos aquí para responder tus preguntas',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Sección de contacto
            Text(
              'Contacto directo',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              context,
              icon: Icons.email,
              title: 'Correo electrónico',
              subtitle: 'Envíanos un mensaje directamente',
              value: 'soporte@fakestore.com',
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              context,
              icon: Icons.phone,
              title: 'Teléfono',
              subtitle: 'Horario: L-V 9:00 a 18:00',
              value: '+1 234 567 890',
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              context,
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
            _buildFAQItem(
              context,
              question: '¿Cómo realizo un pedido?',
              answer: 'Puedes agregar productos al carrito desde el catálogo y proceder al checkout.',
            ),
            _buildFAQItem(
              context,
              question: '¿Cuáles son los métodos de pago?',
              answer: 'Aceptamos tarjetas de crédito/débito, PayPal y transferencias bancarias.',
            ),
            _buildFAQItem(
              context,
              question: '¿Cuánto tarda el envío?',
              answer: 'El envío estándar tarda 3-5 días hábiles. Ofrecemos opción express (24h) con costo adicional.',
            ),
            const SizedBox(height: 10),

           
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, {required String question, required String answer}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(question, style: Theme.of(context).textTheme.titleMedium),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }


}