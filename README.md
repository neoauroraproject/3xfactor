# 3xFactor

[![Visits](https://hits.sh/github.com/neoauroraproject/3xfactor.svg?label=Visits&color=3b82f6&labelColor=05070b)](https://hits.sh/github.com/neoauroraproject/3xfactor/)

<p align="center">
  <img src="assets/banner.jpg" alt="3xFactor — 3x-ui traffic multiplier with built-in panel, by Neo Aurora" width="560">
</p>

### فارسی

یک پنل سبک است که کنار 3x-ui نصب می‌شود و برای هر اینباند یک ضریب مصرف می‌گذارد. `0.5` مصرف ثبت‌شده را نصف می‌کند و `2` آن را دو برابر. ترافیکی که واقعاً از سیم رد می‌شود عوض نمی‌شود؛ فقط عددی که پنل به‌عنوان مصرف می‌نویسد تغییر می‌کند.

برای نصب کلید لایسنس لازم است. کلید فقط یک بار موقع نصب وارد می‌شود و لایسنس روی همان سرور قفل می‌شود. برای تهیهٔ لایسنس به کانال تلگرام [@neoaurora](https://t.me/neoaurora) پیام بدهید.

### English

3xFactor is a small panel that installs next to 3x-ui and sets a traffic multiplier on each inbound. `0.5` records half the real usage, and `2` records double. Packets on the wire stay the same. Only the usage number written by the panel changes.

Installing requires a license key. The key is entered once during install, and the license is locked to that server. To get a license, message [@neoaurora](https://t.me/neoaurora) on Telegram.

### نصب / Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/neoauroraproject/3xfactor/main/install.sh)
```

با اجرای همین دستور یک منو می‌آید: نصب، به‌روزرسانی، تغییر لایسنس، تغییر رمز، حذف، وضعیت.

The same command opens a menu: install, update, change license, password, uninstall, status.

وضعیت لایسنس، زمان باقی‌مانده و تاریخ انقضا در بخش «لایسنس» پنل دیده می‌شود و با دکمهٔ «بررسی الان» می‌شود تمدید را فوراً دریافت کرد.

The panel's License section shows the status, time left and expiry date. The "Check now" button picks up a renewal right away.

ضریب هر اینباند در فایلی کنار Xray ذخیره می‌شود. بعد از نصب پچ، همان فایل حدود هر دو ثانیه خوانده می‌شود و روی شمارندهٔ مصرف همان اینباند اعمال می‌گردد. ضریب `1` یعنی بدون تغییر. وقتی لایسنس تمام شود، همهٔ ضریب‌ها به `1` برمی‌گردند.

Each ratio is stored in a file next to Xray. After the patch is installed, that file is read about every two seconds and applied to that inbound’s counter. A ratio of `1` leaves usage unchanged. When the license ends, every ratio goes back to `1`.

---

<div align="center">

💖 Donation / حمایت مالی  
USDT (BEP20): 0xacA935a5955a756BedaE4738304274EdeE0223D5

Released under the MIT License

Crafted with ♥ by the HMPanel Team

</div>
