import 'package:zakat_fund/chatbot/data/models/message_model.dart';
import 'package:zakat_fund/chatbot/data/models/suggestion_model.dart';

abstract class SuggestionsDataSource {
  List<SuggestionModel> getSuggestions();
}

class SuggestionsDataSourceImpl implements SuggestionsDataSource {
  @override
  List<SuggestionModel> getSuggestions() {
    return <SuggestionModel>[
      SuggestionModel(
        id: 1,
        titleAr: 'التبرع لوقف',
        titleEn: 'Donate to an endowment',
        messageAr: MessageModel.fromJson({
          'reply':
              'تقدر تتبرع للوقف إلكترونياً عبر القنوات الرقمية: تسجّل بياناتك، تختار مشروع الوقف اللي تبي تدعمه، وتحدد طريقة الدفع المناسبة (بطاقات بنكية أو المحفظة الرقمية مثل Apple Pay وSamsung Pay أو الخصم المباشر).',
          'metadata': {
            'title': 'التبرع للوقف ,التبرع لوقف',
            'starting': 'تبغي نبدأ الحين؟',
            'more_info': false,
          },
          'category_id': 2,
          'serviceCardAID': 7,
          'service_code': '400-01',
          'language_code': 'ar',
          'createdAt': '2026-01-21T13:27:24.525Z',
          'serviceCard': {
            'serviceCardAID': 7,
            'serviceNameEn': 'Endowment donation',
            'serviceNameAr': 'التبرع للوقف ,التبرع لوقف',
            'desc':
                'This service allows the individual to donate electronically through digital channels, where the donor can register his data and then choose the type of project he wishes to donate to and specify the available payment options such as bank cards, including debit/credit/prepaid cards or the digital wallet, which is Apple Pay, Samsung Pay, or Direct debit bank accounts.',
            'key': 'm-donations',
            'service_code': '400-01',
            'name': 'التبرع للوقف ,التبرع لوقف',
          },
        }),
        messageEn: MessageModel.fromJson({
          'reply':
              'You can donate to an endowment electronically through the Authority’s digital channels by registering your details, choosing the project you’d like to support, and completing payment using available options (bank cards or digital wallets).',
          'metadata': {
            'title': 'Endowment donation',
            'starting': 'Do you want to start now?',

            'more_info': false,
          },
          'category_id': 2,
          'serviceCardAID': 7,
          'service_code': '400-01',
          'language_code': 'en',
          'createdAt': '2026-01-21T14:58:26.471Z',
          'serviceCard': {
            'serviceCardAID': 7,
            'serviceNameEn': 'Endowment donation',
            'serviceNameAr': 'التبرع للوقف ,التبرع لوقف',
            'desc':
                'This service allows the individual to donate electronically through digital channels, where the donor can register his data and then choose the type of project he wishes to donate to and specify the available payment options such as bank cards, including debit/credit/prepaid cards or the digital wallet, which is Apple Pay, Samsung Pay, or Direct debit bank accounts.',
            'key': 'm-donations',
            'service_code': '400-01',
            'name': 'Endowment donation',
          },
        }),
      ),
      SuggestionModel(
        id: 2,
        titleAr: 'حساب ودفع الزكاة',
        titleEn: 'Calculate and pay Zakat',
        messageAr: MessageModel.fromJson({
          'reply':
              'أكيد. تقدر تستخدم خدمتين حسب اللي تبيه: 1) احتساب الزكاة: نحسب لك الزكاة ونحدد قيمتها ونبلغك بقيمة النصاب بشكل يومي لمختلف أنواع الأموال (نقود، ذهب، فضة، أسهم وغيرها). 2) دفع الزكاة: تقدر تدفع الزكاة/زكاة الفطر/الصدقة عبر قنوات رقمية وتقليدية وبوسائل دفع متعددة مثل النقد والشيكات وبطاقات الائتمان والخصم وApple/Samsung Pay، وبعد الدفع توصلك رسالة نصية بتأكيد السداد. تبغي تبدأ بالحساب ولا بالدفع؟',
          'metadata': {
            'title': 'احتساب الزكاة',
            'starting': 'تبغي نبدأ الحين؟',

            'more_info': true,
          },
          'category_id': 2,
          'serviceCardAID': 26,
          'service_code': '900-03',
          'language_code': 'ar',
          'createdAt': '2026-01-21T13:33:21.110Z',
          'serviceCard': {
            'serviceCardAID': 26,
            'serviceNameEn': 'Zakat Calculation',
            'serviceNameAr': 'احتساب الزكاة',
            'desc':
                'Thanks to this service, we are always ready to calculate your Zakat, determine its value and inform you of the Nisab value (The Nisab: the minimum amount of types of money in which zakat is obligatory) on a daily basis, no matter what kind of money you have: money, gold, silver, livestock, crops and fruits, stocks, companies, free professions, exploits (such as cars and rented buildings), through direct and self-service service centers.',
            'key': 'zakat_calculator',
            'service_code': '900-03',
            'name': 'احتساب الزكاة',
          },
        }),
        messageEn: MessageModel.fromJson({
          'reply':
              'You can use our Zakat services to both calculate your Zakat and then pay it. • Zakat Calculation: We can calculate your Zakat, determine its value, and inform you of the Nisab value for different types of wealth (cash, gold, silver, livestock, crops, stocks, companies, and more) through direct and self-service centers. • Zakat Payment: We receive Zakat/Zakat Al-Fitr/Sadaqah via cash, cheques, credit/debit cards, Apple/Samsung Pay, and other digital/traditional channels. You can also allocate your Zakat to specific categories or entities, and you’ll receive an SMS confirmation after payment. Do you want to start now?',
          'metadata': {
            'title': 'Zakat Calculation',
            'starting': 'Do you want to start now?',

            'more_info': true,
          },
          'category_id': null,
          'serviceCardAID': 26,
          'service_code': '900-03',
          'language_code': 'en',
          'createdAt': '2026-01-21T15:00:18.887Z',
          'serviceCard': {
            'serviceCardAID': 26,
            'serviceNameEn': 'Zakat Calculation',
            'serviceNameAr': 'احتساب الزكاة',
            'desc':
                'Thanks to this service, we are always ready to calculate your Zakat, determine its value and inform you of the Nisab value (The Nisab: the minimum amount of types of money in which zakat is obligatory) on a daily basis, no matter what kind of money you have: money, gold, silver, livestock, crops and fruits, stocks, companies, free professions, exploits (such as cars and rented buildings), through direct and self-service service centers.',
            'key': 'zakat_calculator',
            'service_code': '900-03',
            'name': 'Zakat Calculation',
          },
        }),
      ),
    ];
  }
}
