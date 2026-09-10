-- MIT 8103 Advanced Database Systems
-- Portfolio 3: Atomic Inventory Transfer

CREATE OR REPLACE FUNCTION transfer_inventory(
    p_source_branch BIGINT,
    p_destination_branch BIGINT,
    p_product BIGINT,
    p_quantity INTEGER
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    v_source_quantity INTEGER;
    v_locked_rows INTEGER;
BEGIN
    IF p_source_branch = p_destination_branch THEN
        RAISE EXCEPTION
            'Source and destination branches must be different';
    END IF;

    IF p_quantity <= 0 THEN
        RAISE EXCEPTION
            'Transfer quantity must be greater than zero';
    END IF;

    -- Lock both inventory rows in a consistent order.
    -- Consistent lock ordering reduces deadlock risk.
    PERFORM branch_id
    FROM inventory
    WHERE product_id = p_product
      AND branch_id IN (
          p_source_branch,
          p_destination_branch
      )
    ORDER BY branch_id
    FOR UPDATE;

    GET DIAGNOSTICS v_locked_rows = ROW_COUNT;

    IF v_locked_rows <> 2 THEN
        RAISE EXCEPTION
            'Inventory record is missing for one or both branches';
    END IF;

    SELECT quantity
    INTO v_source_quantity
    FROM inventory
    WHERE branch_id = p_source_branch
      AND product_id = p_product;

    IF v_source_quantity < p_quantity THEN
        RAISE EXCEPTION
            'Insufficient inventory. Available: %, requested: %',
            v_source_quantity,
            p_quantity;
    END IF;

    UPDATE inventory
    SET
        quantity = quantity - p_quantity,
        updated_at = CURRENT_TIMESTAMP
    WHERE branch_id = p_source_branch
      AND product_id = p_product;

    UPDATE inventory
    SET
        quantity = quantity + p_quantity,
        updated_at = CURRENT_TIMESTAMP
    WHERE branch_id = p_destination_branch
      AND product_id = p_product;
END;
$$;

COMMENT ON FUNCTION transfer_inventory(
    BIGINT,
    BIGINT,
    BIGINT,
    INTEGER
) IS
'Atomically transfers product inventory between two branches using row-level locks';