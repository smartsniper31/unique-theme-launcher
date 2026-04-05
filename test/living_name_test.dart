import 'package:flutter_test/flutter_test.dart';
import 'package:unique_theme_launcher/presentation/providers/living_name_provider.dart';
import 'package:unique_theme_launcher/presentation/widgets/name_animations.dart';

void main() {
  // Initialize Flutter binding for tests
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LivingNameProvider', () {
    late LivingNameProvider provider;

    setUp(() {
      provider = LivingNameProvider();
    });

    tearDown(() {
      provider.dispose();
    });

    group('State Calculation', () {
      test('Should return ASLEEP state between 22h and 6h', () {
        provider.updateHour(23);
        expect(provider.currentState, LivingNameState.asleep);

        provider.updateHour(5);
        expect(provider.currentState, LivingNameState.asleep);

        provider.updateHour(6);
        expect(provider.currentState, isNot(LivingNameState.asleep));
      });

      test('Should return WAKING state on first unlock between 6h-10h', () {
        provider.updateHour(7);
        provider.setFirstUnlockToday(true);
        expect(provider.currentState, LivingNameState.waking);

        provider.updateHour(15); // Hors de la plage
        expect(provider.currentState, isNot(LivingNameState.waking));
      });

      test('Should return SAD state when battery < 15%', () {
        provider.updateBatteryLevel(0.14);
        expect(provider.currentState, LivingNameState.sad);
      });

      test('Should return HUNGRY state when battery 15-20%', () {
        provider.updateBatteryLevel(0.18);
        expect(provider.currentState, LivingNameState.hungry);

        provider.updateBatteryLevel(0.14); // < 15%
        expect(provider.currentState, LivingNameState.sad);

        provider.updateBatteryLevel(0.25); // > 20%
        expect(provider.currentState, isNot(LivingNameState.hungry));
      });

      test('Should return HAPPY state on birthday', () {
        provider.setIsBirthday(true);
        expect(provider.currentState, LivingNameState.happy);

        provider.setIsBirthday(false);
        expect(provider.currentState, isNot(LivingNameState.happy));
      });

      test('Should return TIRED state with screenTime > 120 minutes', () {
        provider.updateScreenTime(121);
        provider.updateHour(14);
        expect(provider.currentState, LivingNameState.tired);

        provider.updateScreenTime(120);
        expect(provider.currentState, isNot(LivingNameState.tired));
      });

      test('Should return PLAYFUL state between 18h-22h', () {
        provider.updateHour(19);
        expect(provider.currentState, LivingNameState.playful);

        provider.updateHour(17);
        expect(provider.currentState, isNot(LivingNameState.playful));
      });

      test('Should return ENERGETIC state in morning with high battery', () {
        provider.updateHour(8);
        provider.updateBatteryLevel(0.75);
        provider.setFirstUnlockToday(false);
        expect(provider.currentState, LivingNameState.energetic);

        provider.updateBatteryLevel(0.18); // Batterie basse (15-20%)
        expect(provider.currentState, LivingNameState.hungry);
      });

      test('Priority: Birthday overrides all conditions', () {
        provider.updateHour(23);
        provider.updateBatteryLevel(0.05);
        provider.setIsBirthday(true);
        expect(provider.currentState, LivingNameState.happy);
      });

      test('Priority: Battery < 15% overrides usage', () {
        provider.updateBatteryLevel(0.10);
        provider.updateScreenTime(200);
        expect(provider.currentState, LivingNameState.sad);
      });

      test('Priority: Battery 15-20% overrides night time', () {
        provider.updateHour(23);
        provider.updateBatteryLevel(0.18);
        expect(provider.currentState, LivingNameState.hungry);
      });
    });

    group('State Change Notification', () {
      test('Should notify listeners when state changes', () async {
        int notificationCount = 0;
        provider.addListener(() {
          notificationCount++;
        });

        provider.updateBatteryLevel(0.10); // Devrait changer l'état
        await Future.delayed(const Duration(milliseconds: 100));

        expect(notificationCount, greaterThan(0));
      });

      test('Should not notify listeners when state does not change', () async {
        provider.updateHour(12);
        provider.updateBatteryLevel(0.50);
        final initialState = provider.currentState;

        int notificationCount = 0;
        provider.addListener(() {
          notificationCount++;
        });

        // Même update
        provider.updateBatteryLevel(0.50);
        await Future.delayed(const Duration(milliseconds: 100));

        expect(provider.currentState, initialState);
        expect(notificationCount, 0);
      });
    });

    group('Condition Getters', () {
      test('Should return current conditions as map', () {
        provider.updateHour(14);
        provider.updateBatteryLevel(0.75);
        provider.updateScreenTime(60);

        final conditions = provider.getCurrentConditions();

        expect(conditions['hour'], 14);
        expect(conditions['screenTimeMinutes'], 60);
        expect(conditions['currentState'], isNotNull);
      });
    });
  });

  group('LivingNameState Extension', () {
    test('Should return correct emoji for each state', () {
      expect(LivingNameState.asleep.emoji, '😴');
      expect(LivingNameState.waking.emoji, '☀️');
      expect(LivingNameState.energetic.emoji, '⚡');
      expect(LivingNameState.tired.emoji, '😫');
      expect(LivingNameState.happy.emoji, '🎉');
      expect(LivingNameState.sad.emoji, '😢');
      expect(LivingNameState.hungry.emoji, '🔋');
      expect(LivingNameState.playful.emoji, '😏');
    });

    test('Should return correct label for each state', () {
      expect(LivingNameState.asleep.label, 'Endormi');
      expect(LivingNameState.waking.label, 'Réveil');
      expect(LivingNameState.energetic.label, 'Énergique');
      expect(LivingNameState.tired.label, 'Fatigué');
      expect(LivingNameState.happy.label, 'Heureux');
      expect(LivingNameState.sad.label, 'Triste');
      expect(LivingNameState.hungry.label, 'Affamé');
      expect(LivingNameState.playful.label, 'Joueur');
    });

    test('Should return different color for each state', () {
      final colors = <String>[];
      for (final state in LivingNameState.values) {
        colors.add(state.getColor().toString());
      }

      // Tous les états doivent avoir une couleur unique
      expect(colors.toSet().length, LivingNameState.values.length);
    });
  });

  group('Animation Builders', () {
    test('Should create correct animation builder for each state', () {
      expect(
        getAnimationBuilder(LivingNameState.asleep),
        isA<AsleepAnimation>(),
      );
      expect(
        getAnimationBuilder(LivingNameState.waking),
        isA<WakingAnimation>(),
      );
      expect(
        getAnimationBuilder(LivingNameState.energetic),
        isA<EnergeticAnimation>(),
      );
      expect(
        getAnimationBuilder(LivingNameState.tired),
        isA<TiredAnimation>(),
      );
      expect(
        getAnimationBuilder(LivingNameState.happy),
        isA<HappyAnimation>(),
      );
      expect(
        getAnimationBuilder(LivingNameState.sad),
        isA<SadAnimation>(),
      );
      expect(
        getAnimationBuilder(LivingNameState.hungry),
        isA<HungryAnimation>(),
      );
      expect(
        getAnimationBuilder(LivingNameState.playful),
        isA<PlayfulAnimation>(),
      );
    });

    test('Animation builders should have correct emoji', () {
      expect(AsleepAnimation().emoji, '😴');
      expect(WakingAnimation().emoji, '☀️');
      expect(EnergeticAnimation().emoji, '⚡');
      expect(TiredAnimation().emoji, '😫');
      expect(HappyAnimation().emoji, '🎉');
      expect(SadAnimation().emoji, '😢');
      expect(HungryAnimation().emoji, '🔋');
      expect(PlayfulAnimation().emoji, '😏');
    });
  });
}
