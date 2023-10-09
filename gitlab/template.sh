version=0.6.26

for proj in *;
do
	(
	pushd $proj/nightly@*
	helm dependency update 
	helm template -f values.yaml -f overrideValues.yaml . > manifest_$version.yaml
	popd
	)
done

