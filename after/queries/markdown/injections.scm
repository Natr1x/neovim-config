;; extends

; Alias "csharp" to "c_sharp" since it's more common
((fenced_code_block
  (info_string
    (language) @allan
    (#eq? @allan "csharp")
    (#set! injection.language "c_sharp"))
  (code_fence_content) @injection.content))
