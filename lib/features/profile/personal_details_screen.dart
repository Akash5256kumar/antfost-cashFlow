import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/utils/input_validators.dart';
import 'domain/entities/user_profile.dart';
import 'presentation/bloc/profile_bloc.dart';
import 'presentation/bloc/profile_event.dart';
import 'presentation/bloc/profile_state.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _companyController;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _companyController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _populateData(UserProfile profile) {
    if (!_isInitialized) {
      _nameController.text = profile.name;
      _emailController.text = profile.email;
      _phoneController.text = profile.phone;
      _companyController.text = profile.company;
      _isInitialized = true;
    }
  }

  void _handleSave(UserProfile currentProfile) {
    if (!_formKey.currentState!.validate()) return;

    final updatedProfile = UserProfile(
      id: currentProfile.id,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      company: _companyController.text.trim(),
      avatarUrl: currentProfile.avatarUrl,
      isKycVerified: currentProfile.isKycVerified,
      accountType: currentProfile.accountType,
    );

    context.read<ProfileBloc>().add(UpdateProfileEvent(updatedProfile));
  }

  void _pickNewAvatar() {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(
          content: Text('Avatar upload feature will be available soon.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(
                content: Text('Personal details updated successfully!'),
                backgroundColor: AppColors.primary,
              ),
            );
          // Refresh profile data
          context.read<ProfileBloc>().add(const FetchProfileEvent());
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
        }
      },
      builder: (context, state) {
        // Never render demo data while the real profile is loading.  Apart
        // from being misleading, it can briefly show the wrong account type
        // and KYC state before /me completes.
        if (state is! ProfileSuccess) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textDark,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text('Personal Details'),
              centerTitle: true,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        final profile = state.profile;
        _populateData(profile);
        final isBusiness = profile.accountType.toLowerCase() == 'business';

        final isSaving = state is ProfileLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textDark,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Personal Details',
              style: TextStyle(
                fontSize: context.scaled(18),
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.scaled(16),
                vertical: context.scaledV(20),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Avatar with edit button
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: context.scaled(96),
                            height: context.scaled(96),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryContainer,
                              border: Border.all(
                                color: AppColors.white,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: profile.avatarUrl != null
                                  ? Image.network(
                                      profile.avatarUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) =>
                                          _avatarFallback(),
                                    )
                                  : _avatarFallback(),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: _pickNewAvatar,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: EdgeInsets.all(context.scaled(8)),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.white,
                                    width: 2.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  size: context.scaled(16),
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.scaledV(16)),

                    // KYC is a business-only concept in the current flow.
                    if (isBusiness)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.scaled(14),
                          vertical: context.scaledV(6),
                        ),
                        decoration: BoxDecoration(
                          color: profile.isKycVerified
                              ? AppColors.successContainer
                              : AppColors.warningContainer,
                          borderRadius: BorderRadius.circular(
                            context.scaled(20),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              profile.isKycVerified
                                  ? Icons.verified_rounded
                                  : Icons.info_outline_rounded,
                              size: context.scaled(16),
                              color: profile.isKycVerified
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                            SizedBox(width: context.scaled(6)),
                            Flexible(
                              child: Text(
                                profile.isKycVerified
                                    ? 'KYC Verified Account'
                                    : 'KYC Verification Pending',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: context.scaled(12),
                                  fontWeight: FontWeight.w600,
                                  color: profile.isKycVerified
                                      ? AppColors.success
                                      : AppColors.warning,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: context.scaledV(24)),

                    // Fields Group
                    Container(
                      padding: EdgeInsets.all(context.scaled(16)),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(context.scaled(18)),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            label: 'Full Name',
                            controller: _nameController,
                            icon: Icons.person_outline_rounded,
                            validator: InputValidators.fullName,
                          ),
                          SizedBox(height: context.scaledV(16)),
                          _buildTextField(
                            label: isBusiness ? 'Email' : 'Email (optional)',
                            controller: _emailController,
                            icon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? null
                                : InputValidators.email(value),
                          ),
                          SizedBox(height: context.scaledV(16)),
                          _buildTextField(
                            label: 'Phone Number',
                            controller: _phoneController,
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: InputValidators.phone,
                          ),
                          if (profile.accountType == 'business') ...[
                            SizedBox(height: context.scaledV(16)),
                            _buildTextField(
                              label: 'Company Name',
                              controller: _companyController,
                              icon: Icons.business_rounded,
                              validator: (value) => InputValidators.fullName(
                                value,
                                fieldName: 'Company name',
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: context.scaledV(16)),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                context.scaled(16),
                context.scaledV(12),
                context.scaled(16),
                context.scaledV(16),
              ),
              child: PrimaryButton(
                label: 'Save Changes',
                isLoading: isSaving,
                onPressed: () => _handleSave(profile),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _avatarFallback() {
    return Container(
      color: AppColors.primaryContainer,
      child: Center(
        child: Icon(
          Icons.person_rounded,
          size: context.scaled(48),
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: context.scaled(13),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF777777),
          ),
        ),
        SizedBox(height: context.scaledV(6)),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(
            fontSize: context.scaled(15),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1A1A1A),
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: AppColors.primary,
              size: context.scaled(20),
            ),
            filled: true,
            fillColor: const Color(0xFFF9F9FB),
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.scaled(16),
              vertical: context.scaledV(14),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.scaled(12)),
              borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.scaled(12)),
              borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.scaled(12)),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
