if not nixCats('general') then
  return
end

require('orgmode').setup({
  org_agenda_files = "~/org/agenda/*",
  org_default_notes_file = "~/org/refile.org",
  org_startup_folded = "showeverything"
})

require('org-bullets').setup()
