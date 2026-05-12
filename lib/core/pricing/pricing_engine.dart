class PricingEngine {
  double calculateCost({
    required int inputTokens,
    required int outputTokens,
    int? cachedTokens,
    int? reasoningTokens,
    required double inputPricePer1M,
    required double outputPricePer1M,
    double? cachedInputPricePer1M,
    double? reasoningOutputPricePer1M,
  }) {
    double cost = 0;

    cost += (inputTokens / 1000000) * inputPricePer1M;
    cost += (outputTokens / 1000000) * outputPricePer1M;

    if (cachedTokens != null && cachedInputPricePer1M != null) {
      cost += (cachedTokens / 1000000) * cachedInputPricePer1M;
    }

    if (reasoningTokens != null && reasoningOutputPricePer1M != null) {
      cost += (reasoningTokens / 1000000) * reasoningOutputPricePer1M;
    }

    return cost;
  }

  double? calculateCostFromPriceMap({
    required int inputTokens,
    required int outputTokens,
    int? cachedTokens,
    int? reasoningTokens,
    required Map<String, double> prices,
  }) {
    final inputPrice = prices['input_price_per_1m'];
    final outputPrice = prices['output_price_per_1m'];

    if (inputPrice == null || outputPrice == null) {
      return null;
    }

    return calculateCost(
      inputTokens: inputTokens,
      outputTokens: outputTokens,
      cachedTokens: cachedTokens,
      reasoningTokens: reasoningTokens,
      inputPricePer1M: inputPrice,
      outputPricePer1M: outputPrice,
      cachedInputPricePer1M: prices['cached_input_price_per_1m'],
      reasoningOutputPricePer1M: prices['reasoning_output_price_per_1m'],
    );
  }
}
