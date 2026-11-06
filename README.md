# قدور AI

مساعد ذكاء اصطناعي عام ومصغّر، يستهدف Android والويب من قاعدة Flutter واحدة.

## الحالة الحالية
- تأسيس مشروع Flutter.
- واجهة عربية RTL متجاوبة.
- شاشة محادثة أولية وعناصر واجهة للمحادثات.
- محرك الذكاء الاصطناعي وتسجيل الدخول والتخزين السحابي لم تُربط بعد.

## التشغيل
```bash
flutter pub get
flutter run
```

## البناء
Android:
```bash
flutter build apk --release
```

Web:
```bash
flutter build web --release
```

## البنية المستهدفة
- Flutter: Android + Web
- Firebase Authentication: حسابات المستخدمين
- Cloud Firestore: المحادثات
- Firebase Functions: بوابة آمنة لنماذج الذكاء الاصطناعي
- نموذج مفتوح المصدر + مزود API اختياري

**الأمان:** لا تضع مفاتيح مزودي الذكاء الاصطناعي داخل تطبيق Flutter أو ملفات الويب. يجب أن تمر الطلبات عبر خادم آمن.
