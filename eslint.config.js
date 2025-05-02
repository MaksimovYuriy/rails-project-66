import { defineConfig } from 'eslint';

export default defineConfig({
  env: {
    browser: true,
    node: true
  },
  extends: ['eslint:recommended'],
  parserOptions: {
    ecmaVersion: 2020
  },
  rules: {
    'no-console': 'warn',
    'no-unused-vars': 'warn',
    semi: ['error', 'always']
  }
});
