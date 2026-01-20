import '../../domain/entities/referral.dart';
import '../../domain/repositories/referral_repository.dart';

class MockReferralRepository implements ReferralRepository {
  @override
  Future<ReferralData> getReferralData() async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 800));

    return ReferralData(
      referralCode: 'FOCUS-JANE-99',
      shareLink: 'https://adhd-stack.app/r/FOCUS-JANE-99',
      referrals: [
        Referral(
          id: '1',
          initials: 'AL',
          name: 'Alex Rivera',
          date: 'Joined Oct 12, 2023',
          status: 'Successful',
          reward: '+1 Grace Day',
          isActive: true,
        ),
        Referral(
          id: '2',
          initials: 'SM',
          name: 'Sarah Miller',
          date: 'Invited Yesterday',
          status: 'Pending',
          reward: null,
          isActive: false,
        ),
      ],
    );
  }
}
