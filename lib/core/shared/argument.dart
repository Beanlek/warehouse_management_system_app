class Arguments {
  final String team;

  Arguments(
    this.team,
  );
}

class SummaryArguments extends Arguments {
  final String sitename;

  SummaryArguments(super.team, this.sitename);
}
