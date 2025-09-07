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
- Решение работает на уровне роутера, не требуя дополнительного ПО на каждом устройстве.

---

## 🎯 Требования:

- PowerShell 5.1+
- MikroTik RouterOS

---

## 💻 Использование

1. Запустить скрипт `Start.ps1`.
2. Скрипт создаст файл `static_dns.rsc` в директории out.
3. Выбрать более подходящий способ импорта:
    * Импорт файла (рекомендуется):
        - Загрузить файл `static_dns.rsc` в/на роутер.
        - Выполнить в терминале:
          ``` bash
          /import file-name=static_dns.rsc verbose=progress
          /file remove static_dns.rsc
          ```
    * Вставка в терминал:
        - Просто скопировать содержимое файла `static_dns.rsc` и вставить прямо в терминал роутера.

> #### Важно:
> Если появляется ошибка `Script Error: failure: entry already exists`, это значит, что старые DNS-записи уже
> существуют.
>
> Удалите их через WinBox (IP -> DNS -> Static) или соответствующей командой в терминале, а затем повторите импорт.
>
> Ключ `verbose` поможет найти, в какой строке произошла ошибка.

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
