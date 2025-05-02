import globals from "globals";
import { defineConfig } from "eslint/config";

export default defineConfig([
  {
    files: ["**/*.{js,mjs,cjs}"],
    languageOptions: { globals: globals.browser },
    rules: {
      'no-console': 'warn', // Предупреждение для использования console
      'no-unused-vars': 'warn', // Предупреждение для неиспользуемых переменных
      'semi': ['error', 'always'] // Ошибка, если нет точки с запятой
    }
  }
]);
