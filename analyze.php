<?php

$percentages = [];

$type_coverage_buckets = [];

$project_count = 0;

foreach (glob('sources/**/**/psalm-summary.json') as $path) {
	$summary = json_decode(file_get_contents($path), true);

	$total_expression_count = $summary['total_expression_count'];
	$mixed_expression_count = $summary['mixed_expression_count'];

	if ($total_expression_count < 10) {
		continue;
	}

	$project_count++;

	foreach ($summary['issue_counts'] as $issue_name => $issue_count) {
		if (!isset($percentages[$issue_name])) {
			$percentages[$issue_name] = [];
		}

		$percentages[$issue_name][] = $issue_count / $total_expression_count;
	}

	$type_coverage = 100 - round(100 * $mixed_expression_count / $total_expression_count);

	if (!isset($type_coverage_buckets[$type_coverage])) {
		$type_coverage_buckets[$type_coverage] = 0;
	}

	$type_coverage_buckets[$type_coverage]++;
}

$issue_percentages = [];

foreach ($percentages as $issue_name => $pcs) {
	$issue_percentages[$issue_name] = round(100 * array_sum($pcs) / $project_count, 4);
}

arsort($issue_percentages);
ksort($type_coverage_buckets);

foreach ($issue_percentages as $issue_name => $pct) {
	echo $issue_name . "\t" . $pct . PHP_EOL;
}

echo PHP_EOL;

foreach ($type_coverage_buckets as $pct => $type_coverage) {
	echo $pct . "\t" . $type_coverage . PHP_EOL;
}

echo PHP_EOL;

