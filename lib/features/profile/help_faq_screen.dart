import 'package:flutter/material.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';

enum _FaqCategory { all, ordering, delivery, payment, qc }

class _FaqItem {
  final String question;
  final String answer;
  final _FaqCategory category;

  const _FaqItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}

class HelpFaqScreen extends StatefulWidget {
  const HelpFaqScreen({super.key});

  @override
  State<HelpFaqScreen> createState() => _HelpFaqScreenState();
}

class _HelpFaqScreenState extends State<HelpFaqScreen> {
  final TextEditingController _searchController = TextEditingController();
  _FaqCategory _selectedCategory = _FaqCategory.all;

  static const List<_FaqItem> _faqs = [
    _FaqItem(
      question: 'How do I choose the correct Concrete Mix Code?',
      answer:
          'Each mix code represents concrete compressive strength according to standard Eurocode / BS EN 206 specifications. For example, C25/30 is ideal for residential footings and slabs, while C35/45 and C40/50 are engineered for heavy structural columns, retaining walls, and commercial towers.',
      category: _FaqCategory.ordering,
    ),
    _FaqItem(
      question: 'How are concrete truck trips and volume calculated?',
      answer:
          'Standard transit mixers carry between 8 m³ and 10 m³ per load. When you specify your total volume (e.g., 25 m³), AntFast automatically calculates the required number of trips (3 trips) and spaces their batching departure to ensure continuous pouring without cold joints.',
      category: _FaqCategory.delivery,
    ),
    _FaqItem(
      question: 'Can I add a concrete pump and cube moulds to my order?',
      answer:
          'Yes! In Step 4 (Other Options) of the New Cash Order wizard, you can toggle Boom Pump / Stationary Pump requirements, on-site certified Quality Technicians, temperature-controlled chilled water mix, and testing cube moulds.',
      category: _FaqCategory.ordering,
    ),
    _FaqItem(
      question: 'How do I track my transit mixer in real-time?',
      answer:
          'Once your batching plant commences loading, navigate to My Orders -> Order Details. You can view the live GPS location of your transit mixer, driver phone contact, estimated time of arrival (ETA), and batch dispatch timestamp.',
      category: _FaqCategory.delivery,
    ),
    _FaqItem(
      question: 'How does wallet payment and refund work?',
      answer:
          'You can pre-load your AntFast Wallet using Credit Card or Net Banking. When an order is placed, funds are safely reserved in escrow and only debited upon successful on-site delivery sign-off. Any unpoured returned volume is refunded back to your wallet ledger instantly.',
      category: _FaqCategory.payment,
    ),
    _FaqItem(
      question: 'Where can I find my official VAT invoice and QC certificates?',
      answer:
          'All paid orders generate FTA-compliant digital VAT invoices with downloadable PDF files in the Invoices tab. You can also view QC Checkpoint test results including on-site slump tests, concrete temperature readings, and 28-day cube strength certificates.',
      category: _FaqCategory.qc,
    ),
    _FaqItem(
      question: 'What is the order cancellation and rescheduling policy?',
      answer:
          'Orders can be rescheduled or cancelled up to 2 hours before the scheduled batching plant departure without penalty. Cancellations after concrete batching has begun may incur material batching costs.',
      category: _FaqCategory.ordering,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_FaqItem> get _filteredFaqs {
    final query = _searchController.text.trim().toLowerCase();
    return _faqs.where((faq) {
      final matchesCategory = _selectedCategory == _FaqCategory.all ||
          faq.category == _selectedCategory;
      final matchesQuery = query.isEmpty ||
          faq.question.toLowerCase().contains(query) ||
          faq.answer.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredFaqs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Help & FAQ',
          style: TextStyle(
            fontSize: context.scaled(18),
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search & Category Header
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                context.scaled(16),
                context.scaledV(8),
                context.scaled(16),
                context.scaledV(16),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F7),
                      borderRadius: BorderRadius.circular(context.scaled(14)),
                      border: Border.all(color: const Color(0xFFE8E8E8)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      style: TextStyle(
                        fontSize: context.scaled(14),
                        color: const Color(0xFF1A1A1A),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search concrete, mix codes, delivery...',
                        hintStyle: TextStyle(
                          fontSize: context.scaled(13),
                          color: const Color(0xFFA0A0A0),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                          size: context.scaled(20),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: context.scaled(16),
                          vertical: context.scaledV(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.scaledV(12)),

                  // Category Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _categoryChip('All Questions', _FaqCategory.all),
                        _categoryChip('Ordering & Mix', _FaqCategory.ordering),
                        _categoryChip('Delivery', _FaqCategory.delivery),
                        _categoryChip('Wallet & Pay', _FaqCategory.payment),
                        _categoryChip('QC & Invoices', _FaqCategory.qc),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // FAQ List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No questions found matching your search.',
                        style: TextStyle(color: Colors.grey[600], fontSize: context.scaled(14)),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(context.scaled(16)),
                      itemCount: filtered.length + 1,
                      itemBuilder: (context, index) {
                        if (index == filtered.length) {
                          return _buildNeedHelpBanner();
                        }
                        final faq = filtered[index];
                        return _buildFaqTile(faq);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryChip(String label, _FaqCategory category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: EdgeInsets.only(right: context.scaled(8)),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedCategory = category),
        selectedColor: AppColors.primary,
        backgroundColor: const Color(0xFFF0F0F5),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF555555),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontSize: context.scaled(12),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.scaled(10)),
          side: BorderSide(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
      ),
    );
  }

  Widget _buildFaqTile(_FaqItem faq) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.scaledV(12)),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.scaled(16)),
          side: const BorderSide(color: Color(0xFFEAEAEA)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            shape: const RoundedRectangleBorder(side: BorderSide.none),
            collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
            tilePadding: EdgeInsets.symmetric(
              horizontal: context.scaled(16),
              vertical: context.scaledV(4),
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.help_outline_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            title: Text(
              faq.question,
              style: TextStyle(
                fontSize: context.scaled(14),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.scaled(16),
                  0,
                  context.scaled(16),
                  context.scaledV(16),
                ),
                child: Text(
                  faq.answer,
                  style: TextStyle(
                    fontSize: context.scaled(13),
                    color: const Color(0xFF555555),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeedHelpBanner() {
    return Container(
      margin: EdgeInsets.only(top: context.scaledV(12), bottom: context.scaledV(24)),
      padding: EdgeInsets.all(context.scaled(16)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF8C80FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(context.scaled(18)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Still have questions?',
                  style: TextStyle(
                    fontSize: context.scaled(15),
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: context.scaledV(4)),
                Text(
                  'Our 24/7 technical team is ready to assist you.',
                  style: TextStyle(
                    fontSize: context.scaled(12),
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: context.scaled(8)),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.contactUs),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.scaled(10)),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: context.scaled(12),
                vertical: context.scaledV(8),
              ),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Contact Us',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
