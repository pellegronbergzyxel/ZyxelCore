xmlport 50019 "eCommerce Import Payment"
{
    Caption = 'eCommerce Import Payment';
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        textelement(eCommerceEnvelope)
        {
            textelement(Header)
            {
                textelement(DocumentVersion)
                {
                }
                textelement(MerchantIdentifier)
                {
                }
            }
            textelement(MessageType)
            {
            }
            textelement(Message)
            {
                textelement(MessageID)
                {
                }
                textelement(SettlementReport)
                {
                    textelement(SettlementData)
                    {
                        textelement(eCommerceSettlementID)
                        {
                        }
                        textelement(TotalAmount)
                        {
                            textattribute(currency)
                            {
                            }
                        }
                        textelement(StartDate)
                        {
                        }
                        textelement(EndDate)
                        {
                        }
                        textelement(DepositDate)
                        {
                        }
                    }
                    textelement(Order)
                    {
                        MinOccurs = Zero;
                        textelement(eCommerceOrderID)
                        {
                        }
                        textelement(MerchantOrderID)
                        {
                        }
                        textelement(ShipmentID)
                        {
                        }
                        textelement(MarketplaceName)
                        {
                        }
                        textelement(Fulfillment)
                        {
                            textelement(MerchantFulfillmentID)
                            {
                            }
                            textelement(PostedDate)
                            {
                            }
                            textelement(Item)
                            {
                                textelement(eCommerceOrderItemCode)
                                {
                                }
                                textelement("<merchantorderitemid>")
                                {
                                    MinOccurs = Zero;
                                    XmlName = 'MerchantOrderItemID';
                                }
                                textelement(SKU)
                                {
                                }
                                textelement(Quantity)
                                {
                                }
                                textelement(ItemPrice)
                                {
                                    textelement(Component)
                                    {
                                        textelement(typeitemprice)
                                        {
                                            XmlName = 'Type';
                                        }
                                        textelement(amountitemprice)
                                        {
                                            XmlName = 'Amount';
                                            textattribute(currencyitemprice)
                                            {
                                                XmlName = 'currency';
                                            }
                                        }
                                    }
                                }
                                textelement(ItemFees)
                                {
                                    textelement(Fee)
                                    {
                                        textelement(typefee)
                                        {
                                            XmlName = 'Type';
                                        }
                                        textelement(amountfee)
                                        {
                                            XmlName = 'Amount';
                                            textattribute(currencyfee)
                                            {
                                                XmlName = 'currency';
                                            }
                                        }
                                    }
                                }
                                textelement(Promotion)
                                {
                                    MinOccurs = Zero;
                                    textelement(MerchantPromotionID)
                                    {
                                    }
                                    textelement(typepromotion)
                                    {
                                        XmlName = 'Type';
                                    }
                                    textelement(amountpromotion)
                                    {
                                        XmlName = 'Amount';
                                        textattribute(currencypromotion)
                                        {
                                            XmlName = 'currency';
                                        }
                                    }
                                }
                            }
                        }
                    }
                    textelement(Refund)
                    {
                        MinOccurs = Zero;
                        textelement(refundeCommerceorderid)
                        {
                            XmlName = 'eCommerceOrderID';
                        }
                        textelement(refundmerchantorderid)
                        {
                            XmlName = 'MerchantOrderID';
                        }
                        textelement(AdjustmentID)
                        {
                        }
                        textelement(refundmarketplacename)
                        {
                            XmlName = 'MarketplaceName';
                        }
                        textelement(fulfillmentrefund)
                        {
                            XmlName = 'Fulfillment';
                            textelement(refundmerchantfulfillmentid)
                            {
                                XmlName = 'MerchantFulfillmentID';
                            }
                            textelement(refundposteddate)
                            {
                                XmlName = 'PostedDate';
                            }
                            textelement(AdjustedItem)
                            {
                                textelement("<eCommerceorderitemcode>")
                                {
                                    XmlName = 'eCommerceOrderItemCode';
                                }
                                textelement(MerchantAdjustmentItemID)
                                {
                                }
                                textelement(refundsku)
                                {
                                    XmlName = 'SKU';
                                }
                                textelement(ItemPriceAdjustments)
                                {
                                    MinOccurs = Zero;
                                    textelement(refundcomponent)
                                    {
                                        XmlName = 'Component';
                                        textelement(refundtypeitemprice)
                                        {
                                            XmlName = 'Type';
                                        }
                                        textelement(refundamountitemprice)
                                        {
                                            XmlName = 'Amount';
                                            textattribute(refundcurrencyitemprice)
                                            {
                                                XmlName = 'currency';
                                            }
                                        }
                                    }
                                }
                                textelement(ItemFeeAdjustments)
                                {
                                    MinOccurs = Zero;
                                    textelement(refundfee)
                                    {
                                        XmlName = 'Fee';
                                        textelement(refundtypefee)
                                        {
                                            XmlName = 'Type';
                                        }
                                        textelement(refundamountfee)
                                        {
                                            XmlName = 'Amount';
                                            textattribute(refundcurrencyfee)
                                            {
                                                XmlName = 'currency';
                                            }
                                        }
                                    }
                                }
                                textelement(PromotionAdjustment)
                                {
                                    MinOccurs = Zero;
                                    textelement(refundmerchantpromotionid)
                                    {
                                        XmlName = 'MerchantPromotionID';
                                    }
                                    textelement(refundtypepromotion)
                                    {
                                        XmlName = 'Type';
                                    }
                                    textelement(refundamountpromotion)
                                    {
                                        XmlName = 'Amount';
                                        textattribute(refundcurrencypromotion)
                                        {
                                            XmlName = 'currency';
                                        }
                                    }
                                }
                            }
                        }
                    }
                    textelement(OtherTransaction)
                    {
                        MinOccurs = Zero;
                        textelement(eCommerceorderidothertransac)
                        {
                            MinOccurs = Zero;
                            XmlName = 'eCommerceOrderID';
                        }
                        textelement(transactiontypeothertransact)
                        {
                            XmlName = 'TransactionType';
                        }
                        textelement(shipmentidothertransact)
                        {
                            MinOccurs = Zero;
                            XmlName = 'ShipmentID';
                        }
                        textelement(TransactionID)
                        {
                        }
                        textelement(posteddateothertransact)
                        {
                            XmlName = 'PostedDate';
                        }
                        textelement(Amount)
                        {
                            textattribute(currencyothertransact)
                            {
                                XmlName = 'currency';
                            }
                        }
                        textelement("<othertransactionitem>")
                        {
                            MinOccurs = Zero;
                            XmlName = 'OtherTransactionItem';
                            textelement(skuothertransactionitem)
                            {
                                XmlName = 'SKU';
                            }
                            textelement(quantityothertransactionitem)
                            {
                                XmlName = 'Quantity';
                            }
                            textelement(amountothertransactionitem)
                            {
                                XmlName = 'Amount';
                                textattribute(currencyothertransactionitem)
                                {
                                    XmlName = 'currency';
                                }
                            }
                        }
                    }
                    textelement(AdvertisingTransactionDetails)
                    {
                        MinOccurs = Zero;
                        textelement(transactiontypeadvtransdetail)
                        {
                            XmlName = 'TransactionType';
                        }
                        textelement(posteddateadvtransdetail)
                        {
                            XmlName = 'PostedDate';
                        }
                        textelement(InvoiceId)
                        {
                        }
                        textelement(BaseAmount)
                        {
                            textattribute(curbaseamountadvtransdetail)
                            {
                                XmlName = 'currency';
                            }
                        }
                        textelement(TaxAmount)
                        {
                            textattribute(curtaxamountadvtransdetail)
                            {
                                XmlName = 'currency';
                            }
                        }
                        textelement(TransactionAmount)
                        {
                            textattribute(curtransamountadvtransdetail)
                            {
                                XmlName = 'currency';
                            }
                        }
                    }
                }
            }
        }
    }
}
