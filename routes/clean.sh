#!/usr/bin/env bash
#
# Route to clean rollback information
#
if may_rollback; then
  lobster_warning "This command will erase the rollback entry, making it so that a rollback is not possible."
  if lobster_confirm "Are you sure?"; then
    rm "$rb_data_dir/hash_rollback.txt"
  fi
fi

if ! may_rollback; then
  lobster_success "The project is clean; rollback will not be possible until after the next pull operation."
else
  lobster_failed
fi
