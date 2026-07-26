# HortWiz Combat Text

![Project Zomboid](https://img.shields.io/badge/Project%20Zomboid-B42-blue)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Performance](https://img.shields.io/badge/Performance-O(1)-brightgreen)

Números de dano flutuantes e HUD de combate, standalone, para Project Zomboid Build 42.

## Requer
- **HortWiz Core** (dependência obrigatória — logger e utilitários compartilhados).

## Features
- Números de dano (brancos para normais, vermelhos com `!` para críticos/backstabs) flutuando sobre os personagens atingidos em `OnWeaponHitCharacter`.
- Zero-GC allocations no loop de renderização (`OnPostRender`).

## Instalação (Manual)
1. Baixe o último `.zip` da aba [Releases](../../releases).
2. Extraia a pasta `hortWiz_CombatText` dentro de `C:\Users\SEU_USUARIO\Zomboid\mods\`.
3. Instale também o **HortWiz Core** (dependência).
4. Ative os dois mods no menu principal do jogo.

## Contribuição
Leia o [CONTRIBUTING.md](CONTRIBUTING.md) antes de enviar Pull Requests. Nós levamos a performance MUITO a sério. Qualquer código com *Vibe Coding* (loops desnecessários no render) será rejeitado.
