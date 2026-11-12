# Sayarnge Booking Authentication Starter

## ပါဝင်သောဖိုင်များ
- `auth.html` — Customer signup / Admin login UI
- `auth.js` — Supabase Auth request flow နှင့် role စစ်ဆေးမှု
- `supabase-config.js` — Supabase project URL နှင့် public anon/publishable key
- `supabase-schema.sql` — Customer role အလိုအလျောက်ဖန်တီးခြင်းနှင့် RLS policy

## စတင်အသုံးပြုရန်
1. Supabase project တစ်ခုဖန်တီးပါ။
2. Project Settings > API မှ Project URL နှင့် anon/publishable key ကို `supabase-config.js` ထဲ ထည့်ပါ။
3. Supabase SQL Editor ထဲ `supabase-schema.sql` ကို run ပါ။
4. GitHub repository root ထဲ ဖိုင် ၅ ခုလုံးကို upload လုပ်ပါ။
5. Website မှ `auth.html` ကိုဖွင့်ပြီး Customer အကောင့်စမ်းဖွင့်ပါ။
6. Admin ကို သတ်မှတ်ရန် `supabase-schema.sql` ထဲရှိ နောက်ဆုံး comment SQL ကို မိမိ Admin email ဖြင့် ပြင်ပြီး SQL Editor တွင် သီးခြား run ပါ။

## လုံခြုံရေးမှတ်ချက်
- Customer အကောင့်သည် default အားဖြင့် `customer` role သာရရှိမည်။
- Browser ကနေ ကိုယ့်ကိုယ်ကို `admin` အဖြစ်ပြောင်းလို့မရပါ။ Admin ကို project owner က SQL Editor မှ သတ်မှတ်ရမည်။
- `service_role` သို့မဟုတ် secret key ကို HTML/JS ထဲ မထည့်ပါနှင့်။
- ဒီ starter သည် authentication foundation ဖြစ်ပြီး booking submission, payment slip upload, admin booking dashboard နှင့် server-side policy များကို မချိတ်ဆက်ရသေးပါ။
- Public frontend အဖြစ်သုံးမည့်အခါ hosting ကို HTTPS ဖြင့်သာ အသုံးပြုပါ။
