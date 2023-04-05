{% macro markup(selling_price, cost_price) %}

CASE WHEN {{cost_price}} > 0 THEN Round((({{selling_price}} - {{cost_price}}) / {{cost_price}}) * 100, 2) ELSE 0 END

{% endmacro %}