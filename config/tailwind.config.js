const defaultTheme = require("tailwindcss/defaultTheme")

module.exports = {
  darkMode: "class",
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
    "./app/components/**/*.{erb,html}"
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Avenir Next", "Inter var", ...defaultTheme.fontFamily.sans],
      },
      keyframes: {
        "fade-in": {
          "0%": {
            opacity: "0"
          },
          "100%": {
            opacity: "1"
          }
        }
      },
      animation: {
        "fade-in": "fade-in 200ms ease-in"
      }
    },
    screens: {
      sm: "640px",
      md: "768px",
      lg: "1024px",
      xl: "1024px",
      "2xl": "1024px",
    },
    minHeight: {
      "12": "12rem",
    }
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography")
  ],
  safelist: [
    // rouge code blocks
    "my-6",
    "py-3",
    "px-4",
    "text-sm",
    "border",
    "rounded-md",
    "overflow-x-scroll",
    // header
    "top-[-4rem]",
    // used by heroicon
    "h-full",
    "w-4",
    "inline-block",
    // markdown
    // blockquotes
    "border-gray-500",
    "text-gray-500",
    "dark:border-gray-400",
    "dark:text-gray-400",
    "border-l-[0.2rem]",
    "ml-2",
    "pl-4",
    "mb-8",
    "py-2",
    // remark form
    "min-h-12",
    // codespan
    "text-sm",
    "border",
    "py-[0.13rem]",
    "px-2",
    "font-mono",
    // ul/ol
    "list-disc",
    "list-decimal",
    "pl-4",
    // general
    "columns-2",
    "columns-3",
    "columns-4",
    "whitespace-pre-wrap",
    // headers
    "leading-[1.1]",
    "!text-6xl",
    "!text-4xl",
    "!text-2xl",
    "!text-xl",
    "!text-lg",
    "!text-md",
    "!text-sm",
    "text-6xl",
    "text-4xl",
    "text-2xl",
    "text-xl",
    "text-lg",
    "text-md",
    "text-sm",
    "font-bold",
    "font-semibold",
    "font-medium",
    "w-full",
    "w-1/5",
    "w-2/5",
    "w-3/5",
    "w-4/5",
    "rounded",
    "rounded-sm",
    "rounded-md",
    // headers
    "first:mt-0",
    "mt-20",
    "mt-12",
    "mt-6",
    "mt-3",
    "mb-3",
    "mb-1",
    // links
    "decoration-inherit",
    "underline"
  ]
}
