return {
  "sphamba/smear-cursor.nvim",
  opts = {
    -- İz efektinin rengi ve hızı için temel ayarlar
    cursor_color = "#d3c6aa", -- İstediğin renk kodu (hex)
    stiffness = 0.6,          -- İzin sertliği / takip hızı (0.1 - 1.0 arası)
    trailing_stiffness = 0.3, -- Arkadaki izin sönme hızı
    distance_stop_animating = 0.6,
  },
}
