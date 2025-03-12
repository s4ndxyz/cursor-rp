# cursor-rp

[简体中文](README.md) | [English](README.en.md) | [Русский](README.ru.md) | [Français](README.fr.md) | [Español](README.es.md)

## مقدمة
وكيل عكسي محلي. المقدمة موجزة، عن قصد.

## التثبيت
قم بتنزيل modifier و ccursor من https://github.com/wisdgod/cursor-rp/releases وأعد تسميتهما بالأسماء القياسية وضعهما في نفس الدليل.

## الإعداد والاستخدام
باستخدام 2999 و .local كمثال:

1. افتح Cursor، استخدم الأمر >Open User Settings في Cursor وانسخ المسار.
2. أغلق Cursor، قم بتطبيق التصحيح (قم بالتشغيل مرة واحدة بعد كل تحديث، وقم بالتشغيل مرة أخرى للاستعادة):
   ```
   modifier --cursor-path /path/to/cursor --port 2999 --suffix .local local
   ```

3. قد يقوم بتعديل ملف hosts بشكل غير صحيح، لذلك قد تحتاج إلى تحديثه يدويًا بإضافة ما يلي:
   ```
   127.0.0.1 api2.cursor.sh.local
   127.0.0.1 api3.cursor.sh.local
   127.0.0.1 repo42.cursor.sh.local
   127.0.0.1 api4.cursor.sh.local
   127.0.0.1 us-asia.gcpp.cursor.sh.local
   127.0.0.1 us-eu.gcpp.cursor.sh.local
   127.0.0.1 us-only.gcpp.cursor.sh.local
   ```

4. تشغيل الخدمة:
   ```
   ccursor /path/to/settings.json
   ```

## الإعدادات المهمة
أضف العناصر التالية في settings.json:
- `ccursor.port`: يتطلب هذا عددًا صحيحًا غير موقع من 16 بت
- `ccursor.lockUpdates`: ما إذا كان يجب قفل التحديثات
- `ccursor.domainSuffix`: .local المذكور أعلاه
- `ccursor.timezone`: معرف المنطقة الزمنية لموقع عنوان IP الخاص بك (معيار IANA)

## آلية التحديث
عند وجود أي تغييرات، استخدم طلبات HTTP GET إلى المسارات التالية:
- `/internal/TokenUpdate`
- `/internal/ChecksumUpdate`
- `/internal/ConfigUpdate`

---

احذف المستودع واهرب في أي وقت. إخلاء المسؤولية مرفق في eula. لن تكون التحديثات متكررة.

Feel free!