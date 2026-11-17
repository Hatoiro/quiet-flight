#!/bin/zsh
# QUIET FLIGHT 用の `flight` コマンドを使えるようにします（1回だけ実行）
#   使い方:  zsh install.sh
DIR="${0:A:h}"
RC="$HOME/.zshrc"
sed -i '' '/# >>> quiet-flight >>>/,/# <<< quiet-flight <<</d' "$RC" 2>/dev/null
cat >> "$RC" <<RCEOF
# >>> quiet-flight >>>
flight() {
  local QF_DIR="$DIR"
  local QF_URL="https://hatoiro.github.io/quiet-flight/"
  case "\$1" in
    dev)   # 手元のファイルをそのまま確認（Ctrl+C で終了）
      (sleep 1; open "http://localhost:8765/") &!
      python3 -m http.server 8765 --directory "\$QF_DIR" ;;
    push)  # 変更を GitHub に送って公開版を更新
      (cd "\$QF_DIR" && git add -A && git commit -m "\${2:-update}" && git push && echo "1〜2分で \$QF_URL に反映されます") ;;
    open|"")
      open "\$QF_URL" ;;
    *) echo "使い方: flight（公開版を開く） / flight dev（手元で確認） / flight push \"メモ\"（公開版を更新）" ;;
  esac
}
# <<< quiet-flight <<<
RCEOF
echo "✓ flight コマンドを登録しました。新しいターミナルを開くか、 source ~/.zshrc を実行してください。"
