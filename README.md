# Boletim Campo Verde 📰

**Boletim_Campoverde** é um app Flutter para criar, visualizar e exportar boletins (ex.: boletins COVID‑19). Ele lê PDFs que contenham texto (não imagens escaneadas), extrai números de posições predefinidas do documento, permite editar os valores e exportar o boletim como imagem.

---

## ✨ Principais funcionalidades

- Carregar um arquivo PDF contendo dados do boletim (botão **CARREGAR PDF COM DADOS**)
- Extrair automaticamente valores (Confirmados, Isolamento, Aguardando Resultado, Recuperados, Internados, Óbitos)
- Editar valores tocando sobre os campos no boletim
- Alterar a data do boletim tocando na data exibida
- Exportar / baixar o boletim como imagem (.jpg) com o nome `boletim <DATA>.jpg`
- Localização: Português (pt-BR)

---

## 🛠️ Requisitos

- Flutter SDK (compatível com Dart >= 3.0)
- Plataformas suportadas: Android, iOS, Web, Windows (dependendo das configurações do Flutter)

---

## 🚀 Como executar

1. Clone o repositório e abra a pasta do projeto:

```bash
git clone <repo-url>
cd boletim_campoverde
```

2. Instale dependências:

```bash
flutter pub get
```

3. Execute no emulador ou dispositivo:

```bash
flutter run
```

Build de produção:

```bash
flutter build apk    # Android
flutter build web    # Web
```

---

## 🔧 Como usar o app

1. Abra o app.
2. Toque em **CARREGAR PDF COM DADOS** e selecione um PDF (deve conter texto pesquisável).
3. O app extrai os números de regiões fixas do PDF e mostra um resumo em tela.
4. Para ajustar qualquer valor, toque no campo correspondente no boletim; digite o número e confirme.
5. Toque na data para alterá-la.
6. Para salvar, toque em **BAIXAR BOLETIM** — o arquivo será baixado como imagem.

> Observação: a extração usa posições de retângulos fixos no PDF. Se o layout do boletim mudar, pode ser necessário ajustar as coordenadas no código.

---

## 📁 Arquivos importantes

- `lib/main.dart` — inicialização e `Provider` de estado
- `lib/home_page.dart` — interface principal, seleção de arquivo e extração de PDF
- `lib/boletim.dart` — widget do boletim (layout, edição e seleção de data)
- `lib/to_image.dart` — captura e download do boletim como imagem
- `pubspec.yaml` — dependências e assets (ex.: `assets/images/fundo-boletim.jpg`)

Dependências relevantes:
- `syncfusion_flutter_pdf` — extração de texto a partir de PDFs
- `file_picker` — seleção de arquivos
- `download` / `file_saver` — salvar / baixar arquivos
- `provider` — gerenciamento de estado
- `intl` — formatação de datas

---

## ⚠️ Limitações e sugestões

- PDFs que contenham texto como imagem (scans sem OCR) não terão os números extraídos; considere rodar OCR antes.
- A extração utiliza retângulos fixos; boletins com layout diferente podem não ser lidos corretamente.

---

## Contribuindo

Contribuições são bem-vindas: abra issues ou envie pull requests com melhorias (ex.: ajuste de coordenadas, suporte a OCR, testes automatizados).

