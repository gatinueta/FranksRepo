for dir in *; do
  git -C $dir branch -m features/fam/530_application_lifecycle_3_1_15
  git -C $dir push origin --delete features/fam/530_application_lifecycle_3_1_14
  git -C $dir push origin -u features/fam/530_application_lifecycle_3_1_15
done

