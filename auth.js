(() => {
  const configured = window.SUPABASE_URL && window.SUPABASE_ANON_KEY &&
    !window.SUPABASE_URL.includes("YOUR_") && !window.SUPABASE_ANON_KEY.includes("YOUR_");
  const message = document.getElementById("message");
  const form = document.getElementById("authForm");
  const submitBtn = document.getElementById("submitBtn");
  const customerTab = document.getElementById("customerTab");
  const adminTab = document.getElementById("adminTab");
  const confirmWrap = document.getElementById("confirmWrap");
  const confirmPassword = document.getElementById("confirmPassword");
  let mode = "customer";

  function show(text) { message.textContent = text; message.classList.add("show"); }
  function setMode(next) {
    mode = next;
    customerTab.classList.toggle("active", mode === "customer");
    adminTab.classList.toggle("active", mode === "admin");
    confirmWrap.style.display = mode === "customer" ? "block" : "none";
    confirmPassword.required = mode === "customer";
    submitBtn.textContent = mode === "customer" ? "Customer အကောင့်ဖွင့်မည်" : "Admin Login ဝင်မည်";
    document.getElementById("password").autocomplete = mode === "customer" ? "new-password" : "current-password";
    message.classList.remove("show");
  }
  customerTab.addEventListener("click", () => setMode("customer"));
  adminTab.addEventListener("click", () => setMode("admin"));

  if (!configured || !window.supabase) {
    show("စတင်အသုံးပြုရန် supabase-config.js ထဲတွင် Supabase Project URL နှင့် anon/publishable key ကို အရင်ထည့်ပါ။");
    submitBtn.disabled = true; return;
  }

  const client = window.supabase.createClient(window.SUPABASE_URL, window.SUPABASE_ANON_KEY, {
    auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true }
  });

  async function getRole(userId) {
    const { data, error } = await client.from("user_roles").select("role").eq("user_id", userId).maybeSingle();
    if (error) throw error;
    return data?.role || null;
  }

  form.addEventListener("submit", async (event) => {
    event.preventDefault(); message.classList.remove("show");
    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value;
    submitBtn.disabled = true;
    try {
      if (mode === "customer") {
        if (password !== confirmPassword.value) throw new Error("Password နှစ်ခု မတူပါ။");
        const { data, error } = await client.auth.signUp({ email, password });
        if (error) throw error;
        show(data.session
          ? "Customer အကောင့်ဖွင့်ပြီးပါပြီ။"
          : "အကောင့်ဖွင့်ပြီးပါပြီ။ Email ထဲက အတည်ပြုလင့်ခ်ကို နှိပ်ပြီးမှ Login ဝင်ပါ။");
      } else {
        const { data, error } = await client.auth.signInWithPassword({ email, password });
        if (error) throw error;
        const role = await getRole(data.user.id);
        if (role !== "admin") {
          await client.auth.signOut();
          throw new Error("ဤအကောင့်တွင် Admin ခွင့်ပြုချက် မရှိပါ။");
        }
        show("Admin Login အောင်မြင်ပါပြီ။ Dashboard ကို နောက်တစ်ဆင့်တွင် ချိတ်ဆက်နိုင်ပါသည်။");
      }
    } catch (error) { show(error.message || "လုပ်ဆောင်မှု မအောင်မြင်ပါ။ ပြန်ကြိုးစားပါ။"); }
    finally { submitBtn.disabled = false; }
  });

  client.auth.getSession().then(async ({ data, error }) => {
    if (error || !data.session) return;
    try {
      const role = await getRole(data.session.user.id);
      if (role === "admin") show("လက်ရှိ Admin အကောင့်ဖြင့် Login ဝင်ထားပါသည်။");
      else if (role === "customer") show("လက်ရှိ Customer အကောင့်ဖြင့် Login ဝင်ထားပါသည်။");
    } catch (_) { show("Session ရှိနေသော်လည်း Role ကို အတည်မပြုနိုင်ပါ။ SQL/RLS ကို စစ်ပါ။"); }
  });
})();
