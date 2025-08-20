# Unlock4Rus

> PowerShell-скрипт для автоматизации загрузки и преобразования файла `hosts` в формат статических `DNS-записей` для
> устройств `MikroTik`.
>
> Позволяет обходить региональные блокировки зарубежных ИИ-сервисов, соцсетей, игр и других ресурсов из России, а также
> блокирует вредные сайты.
>
> За основу взят `hosts` от **[AvenCores](https://github.com/AvenCores/Unlock_AI_and_EN_Services_for_Russia)**.

---

## 🌟 Возможности:

- Разблокировка более 70 популярных сервисов.
- Защита от вредоносных сайтов.
- Все работает на вашем устройстве - без VPN, прокси и сторонних приложений.

---

## 🎯 Требования:

- PowerShell 5.1+
- MikroTik RouterOS

---

## 💻 Использование

- Запустить скрипт `Start.ps1`.
- В директории `out` будут созданы файлы `hosts` и `static_dns.rsc`.
- Загрузить файл `static_dns.rsc` на MikroTik.
- Выполнить в терминале:
  ``` bash
  /import file-name=static_dns.rsc
  /file remove static.rsc
   ```
  Или просто вставить содержимое `static_dns.rsc` в терминал.

---

## ✅ Поддерживаемые сервисы

<details>
  <summary>Развернуть</summary>

### 🛠️ Разработка

- GitHub (API & Copilot)
- JetBrains (Datalore, Plugins, CDN)
- Google AI API

### 🧠 ИИ-сервисы

- ChatGPT / OpenAI (включая Sora)
- Claude
- Grok
- Gemini
- Google AI Studio / NotebookLM / Labs
- Microsoft Copilot
- GitHub Copilot

### 🎵 Музыка

- Spotify
- Tidal
- Deezer

### 📱 Социальные сети

- Instagram
- TikTok
- Truth Social
- Guilded
- 4PDA

### 📈 Продуктивность

- Notion
- Canva
- Intel
- Dell
- Weather.com
- Imgur
- Web Archive

### 🚫 Блокировка вредных сайтов

* Скримеры: `only-fans.*`, `onlyfans.wtf`
* IP-логгеры: `iplogger.org`, `grabify.org` и др.

</details>

---

Полный список доменов смотрите в оригинальном
[`hosts`](https://github.com/AvenCores/Unlock_AI_and_EN_Services_for_Russia/blob/main/source/system/etc/hosts).
