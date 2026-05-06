import { defineConfig } from 'unocss'

// bunch of presets
import { presetUno, presetAttributify, presetIcons } from 'unocss'

export default defineConfig({
  // how to make your rules
  rules: [
    // ['m-1', { margin: '1px' }],
    [/^m-([\.\d]+)$/, ([_, num]) => ({ margin: `${num}px` })],
  ],
  presets: [
    presetUno(), // Required: provides Tailwind-like utilities
    presetAttributify(), // Optional: allows <div flex="~" p="y-2 x-4">
    presetIcons(), // Optional: allows <i class="i-logos-vue"></i>
  ],
})