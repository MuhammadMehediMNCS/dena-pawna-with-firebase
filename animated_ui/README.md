# দেনা-পাওনা — Riverpod + অ্যানিমেশন রিরাইট

এই zip-এ পুরো `lib/` ফোল্ডার আছে, যেখানে পুরো অ্যাপটি GetX থেকে **Riverpod**-এ
মাইগ্রেট করা হয়েছে এবং ৩টি নতুন কাস্টম অ্যানিমেশন যোগ করা হয়েছে, আগের সব
ফিচার (৩-থিম সিস্টেম, isLoading/empty-state ফিক্স, রিসিভ/ডিপোজিট হিস্টোরি,
সার্চ, শেয়ার্ড PersonActions/PersonActionBar, ডিলিট-কনফার্মেশন ইত্যাদি)
অক্ষত রেখে।

## pubspec.yaml-এ যা বদলাতে হবে

```yaml
dependencies:
  flutter_riverpod: ^2.5.1
  flutter_slidable: ^3.1.1
  get_storage: ^2.1.1       # আগের মতোই থাকবে — get_storage, `get` প্যাকেজের অংশ নয়
  firebase_core: ^3.x
  cloud_firestore: ^5.x
  firebase_storage: ^12.x
  image_picker: ^1.x
  shimmer: ^3.x
  intl: ^0.19.x

# এই লাইনটি সরিয়ে দিন:
# get: ^4.6.6
```

`main()`-এ `ProviderScope` দিয়ে পুরো অ্যাপ wrap করা হয়েছে এবং
`GetMaterialApp`-এর বদলে সাধারণ `MaterialApp` ব্যবহার করা হয়েছে।

## ৩টি অ্যানিমেশন — কতটা মিলেছে রেফারেন্স GIF-এর সাথে (honest note)

1. **ListView Animation (সোয়াইপ-রিভিল)** — `flutter_slidable` দিয়ে
   বানানো; লিস্ট আইটেম সোয়াইপ করলে গ্রহণ/জমা/এডিট/ডিলিট-এর রঙিন
   বৃত্তাকার বাটন প্রকাশ পায়। এই প্যাকেজের নিজস্ব motion/animation
   কার্ভ ব্যবহার হয়েছে বলে GIF-এর সাথে নড়াচড়ার গতি/স্টাইল হুবহু না-ও
   মিলতে পারে, তবে কার্যকারিতা (ডিফল্টে লুকানো, সোয়াইপে প্রকাশ) ঠিক
   চাওয়া মতোই।
2. **Liquid Swipe** — `liquid_swipe` প্যাকেজটি অনবোর্ডিং কারুসেলের জন্য
   বানানো, সাধারণ Navigator পেজ-পুশের জন্য না। তাই `CustomClipper<Path>`
   দিয়ে হাতে একটি ঢেউ-আকৃতির ক্লিপ-ট্রানজিশন (`LiquidPageRoute`) বানানো
   হয়েছে, যা GIF-এর "তরল ঢেউ" অনুভূতির একটি approximation — ফ্রেম-বাই-
   ফ্রেম পিক্সেল-পারফেক্ট মিল নয়, তবে ভিজ্যুয়াল আইডিয়া একই। পপ (ফিরে
   যাওয়া) করলে এই একই অ্যানিমেশন স্বয়ংক্রিয়ভাবে উল্টো দিকে চলে।
3. **ListView Click / Search** — তালিকায় ট্যাপ করলে `CardExpandRoute`
   (scale + fade) আর সার্চ আইকনে ট্যাপ করলে `CircularRevealRoute`
   (আইকনের পজিশন থেকে বৃত্তাকার রিভিল) — দুটোই হাতে-লেখা
   `PageRouteBuilder`, রেফারেন্স GIF দুটোর মূল আইডিয়া (কার্ড এক্সপ্যান্ড,
   বৃত্তাকার সম্প্রসারণ) অনুসরণ করে।

## স্থাপত্য সংক্ষেপে

- `providers/person_providers.dart` — একটিমাত্র জেনেরিক `PersonNotifier`
  (কনস্ট্রাক্টরে `collectionName` নেয়), `creditorProvider` ও
  `debtorProvider` নামে দুটো `StateNotifierProvider`।
- `providers/theme_provider.dart` — `themeProvider` + `appColorsProvider`,
  GetStorage দিয়ে পারসিস্ট করা, ডিফল্ট Light।
- `core/transitions/` — তিনটি কাস্টম রুট।
- `isLoading` এখনো `personList.isEmpty` থেকে আলাদাভাবে ট্র্যাক করা হয় —
  তাই শিমার সঠিকভাবে থামে এবং তালিকা সত্যিই খালি হলে
  "কোনো তথ্য পাওয়া যায়নি" দেখায়, আর টোটাল বক্সে শূন্য হলে "০০" দেখায়।

এই সবকিছু কোনো Flutter/Dart কম্পাইলার ছাড়াই হাতে লেখা ও ক্রস-চেক করা
হয়েছে (ইম্পোর্ট পাথ, কনস্ট্রাক্টর সিগনেচার, জেনেরিক টাইপ আর্গুমেন্ট) —
তাই প্রথমবার `flutter pub get` + `flutter run` করার পর ছোটখাটো টাইপো
থাকলে দয়া করে জানাবেন, দ্রুত ঠিক করে দেব।
