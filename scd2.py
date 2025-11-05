def generate_scd2_df_from_history_of_changes(
    df_input: DataFrame,
    id_columns: list[str],
) -> DataFrame:
    window = Window.partitionBy(*id_columns).orderBy(col("extract_day"))

    df_output = df_input.withColumn(
        "valid_from", col("extract_day")
    )

    df_output = df_output.withColumn(
        "valid_to",
        coalesce(
            lead(col("extract_day")).over(window),
            to_date(lit("9999-12-31"), "yyyy-MM-dd"),
        ),
    )

    df_output = df_output.withColumn(
        "is_valid",
        when(
            lead(col("status")).over(window).isNull(),
            lit(True),
        )
        .when(
            (lead(col("status")).over(window) == lit("Deleted"))
            & lead(col("status"), 2).over(window).isNull(),
            lit(True),
        )
        .otherwise(lit(False)),
    )

    df_output = df_output.filter(col("status") == "Active").drop("extract_day", "status")

    return df_output
